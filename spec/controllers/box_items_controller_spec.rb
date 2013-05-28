# encoding: utf-8
require 'spec_helper'

describe BoxItemsController do
  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views 
   
  describe "GET 'index'" do
    before(:each) do
      @si = FactoryGirl.create(:shipment_item)
      @bi = FactoryGirl.create(:box_item, :shipment_item_id => @si.id)
      @bi1 = FactoryGirl.create(:box_item, :shipment_item_id => @si.id, :name => 'a new name')
    end
    it "should index" do
      get 'index', :shipment_item_id => @si.id
      assigns(:box_items).should =~ [@bi, @bi1]
    end
  end

  describe "GET 'new'" do
    before(:each) do
      @si = FactoryGirl.create(:shipment_item)
      @bi = FactoryGirl.attributes_for(:box_item, :shipment_item_id => @si.id)
    end
    it "returns http success for pur_eng" do
      session[:pur_eng] = true
      get 'new', :shipment_item_id => @si.id
      response.should be_success
    end
  end

  describe "GET 'create'" do
    before(:each) do
      @u = FactoryGirl.create(:user)
      @si = FactoryGirl.create(:shipment_item)
      @bi = FactoryGirl.attributes_for(:box_item, :shipment_item_id => @si.id)
      @bi_bad = FactoryGirl.attributes_for(:box_item, :shipment_item_id => @si.id, :name => nil)
    end
    it "should create for src_eng" do
      session[:src_eng] = true
      session[:user_id] = @u.id
      get 'create', :shipment_item_id => @si.id, :box_item => @bi
      redirect_to shipment_item_box_items_path(@si)  #, :notice => "装箱产品已保存！"
    end
    
    it "should render new for data error" do
      session[:src_eng] = true
      session[:user_id] = @u.id
      get 'create', :shipment_item_id => @si.id, :box_item => @bi_bad
      response.should render_template('new')
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      @u = FactoryGirl.create(:user)
      @si = FactoryGirl.create(:shipment_item)
      @bi = FactoryGirl.create(:box_item, :shipment_item_id => @si.id)
    end
    it "returns http success for src_eng" do
      session[:src_eng] = true
      session[:user_id] = @u.id
      get 'edit', :id => @bi.id, :shipment_item_id => @si.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    before(:each) do
      @u = FactoryGirl.create(:user)
      @si = FactoryGirl.create(:shipment_item)
      @bi = FactoryGirl.create(:box_item, :shipment_item_id => @si.id)
    end
    it "should update for pur_eng" do
      session[:pur_eng] = true
      session[:user_id] = @u.id
      get 'update', :id => @bi.id, :shipment_item_id => @si.id, :box_item => {:qty => 2, :name => 'a new name'}
      response.should redirect_to shipment_item_box_items_path(@si)  #, :notice => "装箱产品已更改！"
    end
    
    it "should render edit for data error" do
      session[:src_eng] = true
      session[:user_id] = @u.id
      get 'update', :id => @bi.id, :shipment_item_id => @si.id, :box_item => {:qty => 0, :name => 'a new name'}
      response.should render_template('edit')
    end
  end

  describe "GET 'destroy'" do
    before(:each) do
      @si = FactoryGirl.create(:shipment_item)
      @bi = FactoryGirl.create(:box_item, :shipment_item_id => @si.id)
    end
    it "should destroy for src_eng" do
      session[:src_eng] = true
      get 'destroy', :id => @bi.id, :shipment_item_id => @si.id
      response.should redirect_to shipment_item_box_items_path(@si)  #, :notice => "装箱产品已删除！"
    end
  end

end
