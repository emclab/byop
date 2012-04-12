# encoding: utf-8
require 'spec_helper'

describe ProjectsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for anyone" do
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      get 'index'
      response.should be_success
    end
    
    it "should OK for mech eng" do
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      session[:mech_eng] = true
      get 'index'
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      proj = Factory.attributes_for(:project)
      get 'new'
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow comp_sec" do
      proj = Factory.attributes_for(:project)
      session[:comp_sec] = true
      get 'new'
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      proj = Factory.attributes_for(:project)
      get 'create'
      response.should be_success
    end
    
    it "should OK for vp_sales and increase record count by 1 " do
      session[:vp_sales] = true
      u = Factory(:user)
      proj = Factory.attributes_for(:project, :input_by_id => u.id) 
      lambda do
        get 'create', :project => proj
        response.should redirect_to URI.escape("/view_handler?index=0&msg=项目设备信息已保存！")
        #response.should render_template("new")
      end.should change(Project, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:comp_sec] = true
      u = Factory(:user)
      proj = Factory.attributes_for(:project, :name => nil, :input_by_id => u.id) 
      lambda do
        get 'create', :project => proj
        response.should render_template('new')
      end.should change(Project, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      proj = Factory(:project)
      get 'edit', :id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for comp_sec" do
      cust = Factory(:customer)
      session[:comp_sec] = true
      u = Factory(:user)
      proj = Factory(:project, :input_by_id => u.id, :customer_id => cust.id)
      get 'edit', :id => proj.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      cust = Factory(:customer)
      session[:ceo] = true
      u = Factory(:user)
      proj = Factory(:project, :input_by_id => u.id, :customer_id => cust.id)
      get 'update', :id => proj.id, :project => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=项目设备信息已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      cust = Factory(:customer)
      session[:coo] = true
      u = Factory(:user)
      proj = Factory(:project, :input_by_id => u.id, :customer_id => cust.id)
      get 'update', :id => proj.id, :project => {:tech_spec => nil}
      response.should render_template('edit')
    end
        
  end

  describe "cancel by ceo" do
    it "should be able to cancell the project by ceo" do
      session[:ceo] = true
      session[:user_id] = 1
      proj = Factory(:project)
      put 'cancel', :id => proj.id, :project => {:cancelled => true, :cancel_date => Time.now, 
                                                 :input_by_id => session[:user_id]}
      proj.reload.cancelled.should == true
    end
  end
  
  describe "re activate by ceo" do
    it "should be able to reactivate the project by ceo" do
      session[:ceo] = true
      session[:user_id] = 1
      proj = Factory(:project)
      put 're_activate', :id => proj.id, :project => {:cancelled => false, :cancel_date => Time.now, :input_by_id => session[:user_id]}
      proj.reload.cancelled.should == false
    end
  end  

  describe "GET 'show'" do
    it "should reject those without right" do
      u = Factory(:user)
      proj = Factory(:project, :input_by_id => u.id)
      get 'show', :id => proj.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      cust = Factory(:customer)
      session[:mech_eng] = true
      u = Factory(:user)
      proj = Factory(:project, :input_by_id => u.id, :customer_id => cust.id)
      get 'show', :id => proj.id
      response.should be_success
    end
  end
  
end
