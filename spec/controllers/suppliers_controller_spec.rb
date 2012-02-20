# encoding: utf-8
require 'spec_helper'

describe SuppliersController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for anyone" do
      supl = Factory(:supplier)
      get 'index'
      response.should be_success
    end
    
    it "should OK for src eng" do
      supl = Factory(:supplier)
      session[:pur_eng] = true
      get 'index'
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      supl = Factory.attributes_for(:supplier)
      get 'new'
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow pur eng" do
      supl = Factory.attributes_for(:supplier)
      session[:pur_eng] = true
      get 'new'
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      supl = Factory.attributes_for(:supplier)
      get 'create'
      response.should be_success
    end
    
    it "should OK for pur_eng and increase record count by 1 for pur eng" do
      session[:pur_eng] = true
      u = Factory(:user)
      supl = Factory.attributes_for(:supplier, :input_by_id => u.id) 
      lambda do
        get 'create', :supplier => supl
        response.should redirect_to URI.escape("/view_handler?index=0&msg=供应商信息已保存！")
      end.should change(Supplier, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:pur_eng] = true
      u = Factory(:user)
      supl = Factory.attributes_for(:supplier, :name => nil, :input_by_id => u.id) 
      lambda do
        get 'create', :supplier => supl
        response.should render_template('new')
      end.should change(Supplier, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      supl = Factory(:supplier)
      get 'edit', :id => supl.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp_eng" do
      session[:vp_eng] = true
      u = Factory(:user)
      supl = Factory(:supplier, :input_by_id => u.id)
      get 'edit', :id => supl.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      session[:ceo] = true
      u = Factory(:user)
      supl = Factory(:supplier, :input_by_id => u.id)
      get 'update', :id => supl.id, :supplier => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=供应商信息已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      session[:pur_eng] = true
      u = Factory(:user)
      supl = Factory(:supplier, :input_by_id => u.id)
      get 'update', :id => supl.id, :supplier => {:quality_system => nil}
      response.should render_template('edit')
    end
        
  end

  describe "GET 'show'" do
    it "should reject those without right" do
      u = Factory(:user)
      supl = Factory(:supplier, :input_by_id => u.id)
      get 'show', :id => supl.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      session[:mech_eng] = true
      u = Factory(:user)
      supl = Factory(:supplier, :input_by_id => u.id)
      get 'show', :id => supl.id
      response.should be_success
    end
  end

end
