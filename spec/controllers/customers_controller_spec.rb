# encoding: utf-8
require 'spec_helper'

describe CustomersController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "should be success" do
      cust = Factory(:customer)
      log = Factory(:comm_log, :customer_id => cust.id)
      get 'index'
      response.should be_success
    end
  end

  describe "'new'" do

    it "should reject for those without rights" do
      get 'new'
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
        
    it "should be success for comp_sec" do
      session[:comp_sec] = true
      get 'new'
      response.should be_success
    end
  end

  describe "'create'" do
    it "should be success for ceo" do
      session[:ceo] = true
      session[:user_id] = 1
      cust = Factory.attributes_for(:customer)
      lambda do
        get 'create', :customer => cust
        response.should redirect_to URI.escape("/view_handler?index=0&msg=已保存!")
      end.should change(Customer, :count).by(1)     
    end
    
    it "should redirect to 'new' for wrong data" do
      session[:ceo] = true
      session[:user_id] = 1
      cust = Factory.attributes_for(:customer, :name => nil)
      get 'create', :customer => cust
      response.should render_template('new')
    end    
  end

  describe "'edit'" do
    
    it "should reject those without rights" do
      cust = Factory(:customer)
      get 'edit', :id => cust.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "should success for vp_sales" do
      session[:vp_sales] = true
      cust = Factory(:customer)
      get 'edit', :id => cust.id
      response.should be_success
    end
  end

  describe "'update'" do
    it "should be success for comp_sec" do
      session[:comp_sec] = true
      cust = Factory(:customer)
      session[:user_id] = 1
      get 'update', :id => cust.id, :customer => {:name => "a new name for sure"}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=更改已保存！")
    end
    
    it "should render 'edit' for wrong data" do
      session[:ceo] = true
      cust = Factory(:customer)
      session[:user_id] = 1
      get 'update', :id => cust.id, :customer => { :short_name => nil}
      response.should render_template("edit")
    end
  end

  describe "'show'" do
    it "should rejct for those without right" do
      cust = Factory(:customer)
      get 'show', :id => cust.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
    it "be success for vp_eng" do
      session[:vp_eng] = true
      u = Factory(:user)
      cust = Factory(:customer, :input_by_id => u.id)
      get 'show', :id => cust.id
      response.should be_success
    end
  end
  
end
