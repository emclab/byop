# encoding: utf-8
require 'spec_helper'

describe PurchasingsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for eng" do
      session[:hydr_eng] = true
      proj = Factory(:project)
      pur = Factory(:purchasing, :project_id => proj.id)
      get 'index', :project_id => proj.id
      response.should be_success
    end
    
    it "should OK for mech eng" do
      proj = Factory(:project)
      pur = Factory(:purchasing, :project_id => proj.id)
      session[:mech_eng] = true
      get 'index', :project_id => proj.id
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      proj = Factory(:project)
      pur = Factory.attributes_for(:purchasing, :project_id => proj.id)
      get 'new', :project_id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow vp eng" do
      proj = Factory(:project)
      pur = Factory.attributes_for(:purchasing, :project_id => proj.id)
      session[:vp_eng] = true
      get 'new', :project_id => proj.id
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      proj = Factory(:project)
      pur = Factory.attributes_for(:purchasing, :project_id => proj.id)
      get 'create', :project_id => proj.id, :purchasing => pur
      response.should be_success
    end
    
    it "should OK for vp_eng and increase record count by 1 " do
      session[:vp_eng] = true
      u = Factory(:user)
      proj = Factory(:project)
      pur = Factory.attributes_for(:purchasing, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :purchasing => pur
        response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已保存！")
      end.should change(Purchasing, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:ceo] = true
      u = Factory(:user)
      proj = Factory(:project)
      pur = Factory.attributes_for(:purchasing, :prod_name => nil, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :purchasing => pur
        response.should render_template('new')
      end.should change(Purchasing, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      proj = Factory(:project)
      pur = Factory(:purchasing, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => pur.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp eng" do
      proj = Factory(:project)
      session[:vp_eng] = true
      u = Factory(:user)
      pur = Factory(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => pur.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      proj = Factory(:project)
      session[:ceo] = true
      u = Factory(:user)
      pur = Factory(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => pur.id, :purchasing => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      proj = Factory(:project)
      session[:vp_eng] = true
      u = Factory(:user)
      pur = Factory(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => pur.id, :purchasing => {:order_date => nil}
      response.should render_template('edit')
    end
        
  end

  describe "approve" do
    it "should nothing happens for those without rights" do
      proj = Factory(:project)
      u = Factory(:user)
      session[:user_id] = u.id
      src= Factory(:purchasing, :input_by_id => u.id, :approved_by_vp_eng => false)
      put 'approve', :project_id => proj.id, :id => src.id, :purchasing => {:approved_by_vp_eng => true}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足!")
    end
    
  end
  
  describe "GET 'show'" do
    it "should reject those without right" do
      u = Factory(:user)
      proj = Factory(:project)
      pur = Factory(:purchasing, :input_by_id => u.id, :project_id => proj.id, :eng_id => u.id)
      get 'show', :project_id => proj.id, :id => pur.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      m = Factory(:manufacturer)
      proj = Factory(:project)
      session[:elec_eng] = true
      u = Factory(:user)
      pur = Factory(:purchasing, :input_by_id => u.id, :project_id => proj.id, :manufacturer_id => m.id, :eng_id => u.id)
      get 'show', :project_id => proj.id, :id => pur.id
      response.should be_success
    end
  end
end
