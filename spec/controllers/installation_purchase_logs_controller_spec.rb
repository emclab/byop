# encoding: utf-8
require 'spec_helper'

describe InstallationPurchaseLogsController do

  before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "'new'" do
    it "should be successful for inst eng" do
      session[:inst_eng] = true
      installation = Factory(:installation)
      installation_purchase = Factory(:installation_purchase, :installation_id => installation.id)
      log = Factory.attributes_for(:installation_purchase_log, :installation_purchase_id => installation_purchase.id)      
      get 'new', :installation_purchase_id => installation_purchase.id
      response.should be_success
    end
    
    it "should be successful for vp eng" do
      session[:vp_eng] = true
      installation = Factory(:installation)
      installation_purchase = Factory(:installation_purchase, :installation_id => installation.id)
      log = Factory.attributes_for(:installation_purchase_log, :installation_purchase_id => installation_purchase.id)      
      get 'new', :installation_purchase_id => installation_purchase.id
      response.should be_success
    end    
    
    it "should reject those without rights" do
      installation = Factory(:installation)
      installation_purchase = Factory(:installation_purchase, :installation_id => installation.id)
      log = Factory.attributes_for(:installation_purchase_log, :installation_purchase_id => installation_purchase.id)      
      get 'new', :installation_purchase_id => installation_purchase.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
  end

  describe "'create'" do
    it "should be successful for inst eng" do
      session[:inst_eng] = true
      installation = Factory(:installation)
      installation_purchase = Factory(:installation_purchase, :installation_id => installation.id)
      log = Factory.attributes_for(:installation_purchase_log, :installation_purchase_id => installation_purchase.id)      
      get 'create', :installation_purchase_id => installation_purchase.id, :installation_purchase_log => log
      response.should redirect_to installation_installation_purchase_path(installation, installation_purchase)
    end
    
    it "should increase the installation_purchase_log log count by one for a successful create" do
      session[:vp_eng] = true
      installation = Factory(:installation)
      installation_purchase = Factory(:installation_purchase, :installation_id => installation.id)
      log = Factory.attributes_for(:installation_purchase_log, :installation_purchase_id => installation_purchase.id)  
      lambda do    
        get 'create', :installation_purchase_id => installation_purchase.id, :installation_purchase_log => log
      end.should change(InstallationPurchaseLog, :count).by(1)
    end
        
  end
end
