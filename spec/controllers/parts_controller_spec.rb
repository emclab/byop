# encoding: utf-8
require 'spec_helper'

describe PartsController do
  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for anyone" do
      part = FactoryGirl.create(:part)
      get 'index'
      response.should be_success
    end
    
    it "should OK for mech eng" do
      part = FactoryGirl.create(:part)
      session[:mech_eng] = true
      get 'index'
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      part = FactoryGirl.attributes_for(:part)
      get 'new'
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow comp_sec" do
      part = FactoryGirl.attributes_for(:part)
      session[:pur_eng] = true
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "reject those without right" do
      part = FactoryGirl.attributes_for(:part)
      get 'create'
      response.should be_success
    end
    
    it "should OK for vp_eng and increase record count by 1 " do
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      part = FactoryGirl.attributes_for(:part, :input_by_id => u.id) 
      lambda do
        get 'create', :part => part
       response.should redirect_to URI.escape("/view_handler?index=0&msg=入库物料已保存！")
       #response.should render_template("new")
      end.should change(Part, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:pur_eng] = true
      u = FactoryGirl.create(:user)
      part = FactoryGirl.attributes_for(:part, :name => nil, :input_by_id => u.id) 
      lambda do
        get 'create', :part => part
        response.should render_template('new')
      end.should change(Part, :count).by(0)
    end      
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      part = FactoryGirl.create(:part)
      get 'edit', :id => part.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for pur eng" do
      session[:pur_eng] = true
      u = FactoryGirl.create(:user)
      part = FactoryGirl.create(:part, :input_by_id => u.id)
      get 'edit', :id => part.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      part = FactoryGirl.create(:part, :input_by_id => u.id)
      get 'update', :id => part.id, :part => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=入库物料已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      session[:pur_eng] = true
      u = FactoryGirl.create(:user)
      part = FactoryGirl.create(:part, :input_by_id => u.id)
      get 'update', :id => part.id, :part => {:spec => nil}
      response.should render_template('edit')
    end
        
  end

  describe "GET 'show'" do
    it "returns http success for everyone" do
      session[:mech_eng] = true
      u = FactoryGirl.create(:user)
      part = FactoryGirl.create(:part, :input_by_id => u.id)
      get 'show', :id => part.id
      response.should be_success
    end
  end

end
