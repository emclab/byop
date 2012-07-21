# encoding: utf-8
require 'spec_helper'

describe CommLogsController do

  before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "GET 'new'" do
    it "should be successful for comp_sec" do
      session[:comp_sec] = true
      customer = FactoryGirl.create(:customer)
      log = FactoryGirl.attributes_for(:comm_log, :customer_id => customer.id)      
      get 'new', :customer_id => customer.id
      response.should be_success
    end
    
    it "should be successful for coo" do
      session[:coo] = true
      customer = Factory(:customer)
      log = FactoryGirl.attributes_for(:comm_log, :customer_id => customer.id)      
      get 'new', :customer_id => customer.id
      response.should be_success
    end    
    
    it "should reject those without rights" do
      customer = FactoryGirl.create(:customer)
      log = FactoryGirl.attributes_for(:comm_log, :customer_id => customer.id)      
      get 'new', :customer_id => customer.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
  end

  describe "'create'" do
    it "should be successful for comp_sec" do
      session[:comp_sec] = true
      customer = FactoryGirl.create(:customer)
      log = FactoryGirl.attributes_for(:comm_log, :customer_id => customer.id)      
      get 'create', :customer_id => customer.id, :comm_log => log
      response.should redirect_to customer_path(customer)
    end
    
    it "should increase the comm log count by one for a successful create" do
      session[:ceo] = true
      customer = FactoryGirl.create(:customer)
      log = FactoryGirl.attributes_for(:comm_log, :customer_id => customer.id)  
      lambda do    
        get 'create', :customer_id => customer.id, :comm_log => log
      end.should change(CommLog, :count).by(1)
    end
        
  end

  describe "GET 'show'" do
    it "should be successful for comp sec" do
      session[:comp_sec] = true
      customer = FactoryGirl.create(:customer)
      user = FactoryGirl.create(:user)
      log = FactoryGirl.create(:comm_log, :customer_id => customer.id, :input_by_id => user.id)         
      get 'show', :customer_id => customer.id, :id => log.id
      response.should be_success
    end
  end

  describe "'destroy'" do
    it "should reject those with insufficient rights" do
      customer = FactoryGirl.create(:customer)
      user = FactoryGirl.create(:user)
      log = FactoryGirl.create(:comm_log, :customer_id => customer.id, :input_by_id => user.id)        
      get 'destroy', :customer_id => customer.id, :id => log.id
      flash.now[:error].should == "权限不足！"
    end
    
    it "should destroy for comp_sec" do
      session[:comp_sec] = true
      customer = Factory(:customer)
      user = Factory(:user)
      log = Factory(:comm_log, :customer_id => customer.id, :input_by_id => user.id)        
      get 'destroy', :customer_id => customer.id, :id => log.id
      response.should redirect_to customer_path(customer)      
    end
    
    it "should reduced the comm log count by 1 after a successful delete" do
      session[:vp_sales] = true
      customer = FactoryGirl.create(:customer)
      user = FactoryGirl.create(:user)
      log = FactoryGirl.create(:comm_log, :customer_id => customer.id, :input_by_id => user.id)
      lambda do        
        get 'destroy', :customer_id => customer.id, :id => log.id 
      end.should change(CommLog, :count).by(-1)     
    end
  end
end
