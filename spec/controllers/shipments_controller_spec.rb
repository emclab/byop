# encoding: utf-8
require 'spec_helper'

describe ShipmentsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views  
  
  describe "GET 'index'" do
    before(:each) do
      cust = FactoryGirl.create(:customer)
      @proj = FactoryGirl.create(:project, :customer_id => cust.id)
      @proj1 = FactoryGirl.create(:project, :name => 'a new name', :customer_id => cust.id)
      @si = FactoryGirl.build(:shipment_item)
      @sh = FactoryGirl.create(:shipment, :project_id => @proj.id, :shipping_date => Time.now, :shipment_items => [@si])
      @sh1 = FactoryGirl.create(:shipment, :project_id => @proj1.id, :shipping_date => Time.now - 100.days, :shipment_items => [@si])
    end
    it "returns http success with no project_id passed in" do     
      get 'index'
      assigns(:shipments).should =~[@sh, @sh1]
    end
    
    it "should return shipment for the project_id" do
      get 'index', :project_id => @proj.id
      assigns(:shipments).should =~[@sh]
    end
  end

  describe "GET 'new'" do
    before(:each) do
      cust = FactoryGirl.create(:customer)
      @proj = FactoryGirl.create(:project, :customer_id => cust.id)
      #@sh = FactoryGirl.build(:shipment, :project_id => @proj.id, :shipping_date => Time.now )
    end
    it "should create for src_eng " do
      session[:src_eng] = true
      get 'new', :project_id => @proj.id
      response.should be_success
    end
    
    it "should create for pur_eng " do
      session[:pur_eng] = true
      get 'new', :project_id => @proj.id
      response.should be_success
    end
    
    it "should redirect for user without right" do
      get 'new', :project_id => @proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  describe "GET 'create'" do
    before(:each) do
      cust = FactoryGirl.create(:customer)
      @proj = FactoryGirl.create(:project, :customer_id => cust.id)
      @si = FactoryGirl.attributes_for(:shipment_item)
      @sh = FactoryGirl.attributes_for(:shipment, :project_id => @proj.id, :shipping_date => Time.now, :shipment_items_attributes => [@si])
      @sh_bad = FactoryGirl.attributes_for(:shipment, :project_id => @proj.id, :shipping_date => nil, :shipment_items_attributes => [@si])
      
    end
    it "create for src eng" do
      session[:src_eng] = true
      get 'create', :project_id => @proj.id, :shipment => @sh
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=发货运输已保存！")
    end
    
    it "should render new for data error" do
      session[:pur_eng] = true
      get 'create', :project_id => @proj.id, :shipment => @sh_bad
      response.should render_template('new')
    end
    
    it "should render new for child data error" do
      session[:src_eng] = true
      get 'create', :project_id => @proj.id, :shipment => {:shipping_date => Time.now, :freight_desp => "hi", :delivery_address => 'address one', :shipping_via => 'trucking',  
                                             :shipment_items_attributes => {'1' => {:name => '', :qty => 1, :unit => 'unit', :spec => 'some spec'}}}
      response.should render_template('new')
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      cust = FactoryGirl.create(:customer)
      @si = FactoryGirl.build(:shipment_item)
      @proj = FactoryGirl.create(:project, :customer_id => cust.id)
      @sh = FactoryGirl.create(:shipment, :project_id => @proj.id, :shipping_date => Time.now, :shipment_items => [@si])
    end
    it "should edit for pur_eng" do
      session[:pur_eng] = true
      get 'edit', :project_id => @proj.id, :id => @sh.id
      response.should be_success
    end
    
    it "should redirect for user without right" do
      get 'edit', :project_id => @proj.id, :id => @sh.id
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  describe "GET 'update'" do
    before(:each) do
      cust = FactoryGirl.create(:customer)
      @si = FactoryGirl.build(:shipment_item)
      @proj = FactoryGirl.create(:project, :customer_id => cust.id)
      @sh = FactoryGirl.create(:shipment, :project_id => @proj.id, :shipping_date => Time.now, :shipment_items => [@si])
    end
    it "should update for src_eng" do
      session[:src_eng] = true
      get 'update', :project_id => @proj.id, :id => @sh.id, :shipment => {:carrier => 'new guy', 
                    :shipment_items_attributes => {'1' => {:name => 'a new name', :qty => @si.qty, :unit => @si.unit, :spec => @si.spec, :brief_note => @si.brief_note}}}
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=发货运输已更改！")
    end
    
    it "should render edit for pur_eng with data error" do
      session[:pur_eng] = true
      get 'update', :project_id => @proj.id, :id => @sh.id, :shipment => {:freight_desp => nil}
      response.should render_template('edit')
    end
    
    it "should render edit for src_eng with data error in nested shipment item" do
      session[:src_eng] = true
      get 'update', :project_id => @proj.id, :id => @sh.id, :shipment => {:shipment_items_attributes => {'1' => {:name => '', :qty => @si.qty, :unit => @si.unit, :spec => @si.spec, :brief_note => @si.brief_note}}}
      response.should render_template('edit')
    end
  end

  describe "GET 'show'" do
    before(:each) do
      u = FactoryGirl.create(:user)
      cust = FactoryGirl.create(:customer)
      @si = FactoryGirl.build(:shipment_item)
      @proj = FactoryGirl.create(:project, :customer_id => cust.id)
      @sh = FactoryGirl.create(:shipment, :project_id => @proj.id, :shipping_date => Time.now, :shipment_items => [@si], :input_by_id => u.id)
    end
    it "returns http success for ceo" do
      session[:ceo] = true
      get 'show', :project_id => @proj.id, :id => @sh.id
      response.should be_success
    end
  end

end
