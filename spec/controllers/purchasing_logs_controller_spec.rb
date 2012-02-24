# encoding: utf-8
require 'spec_helper'

describe PurchasingLogsController do

   before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "index" do
    it "should allow for index" do
      u = Factory(:user)
      purchasing = Factory(:purchasing, :input_by_id => u.id)
      get 'index', :purchasing_id => purchasing.id
      response.should be_success
    end
  end
  
  describe "GET 'new'" do
    it "should be successful for mech eng" do
      session[:mech_eng] = true
      purchasing = Factory(:purchasing)
      log = Factory.attributes_for(:purchasing_log, :purchasing_id => purchasing.id)      
      get 'new', :purchasing_id => purchasing.id
      response.should be_success
    end
    
    it "should be successful for coo" do
      session[:coo] = true
      purchasing = Factory(:purchasing)
      log = Factory.attributes_for(:purchasing_log, :purchasing_id => purchasing.id)      
      get 'new', :purchasing_id => purchasing.id
      response.should be_success
    end    
    
    it "should reject those without rights" do
      purchasing = Factory(:purchasing)
      log = Factory.attributes_for(:purchasing_log, :purchasing_id => purchasing.id)      
      get 'new', :purchasing_id => purchasing.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
  end

  describe "'create'" do
    it "should be successful for comp_sec" do
      session[:comp_sec] = true
      purchasing = Factory(:purchasing)
      log = Factory.attributes_for(:purchasing_log, :purchasing_id => purchasing.id)      
      get 'create', :purchasing_id => purchasing.id, :purchasing_log => log
      response.should redirect_to purchasing_path(purchasing)
    end
    
    it "should increase the purchasing log count by one for a successful create" do
      session[:ceo] = true
      purchasing = Factory(:purchasing)
      log = Factory.attributes_for(:purchasing_log, :purchasing_id => purchasing.id)  
      lambda do    
        get 'create', :purchasing_id => purchasing.id, :purchasing_log => log
      end.should change(PurchasingLog, :count).by(1)
    end
        
  end

end
