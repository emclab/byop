# encoding: utf-8
require 'spec_helper'

describe InstallationLogsController do

  before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "index" do
    it "should allow for index" do
      u = Factory(:user)
      installation = Factory(:installation, :input_by_id => u.id)
      get 'index', :installation_id => installation.id
      response.should be_success
    end
  end
  
  describe "GET 'new'" do
    it "should be successful for mech eng" do
      session[:mech_eng] = true
      installation = Factory(:installation)
      log = Factory.attributes_for(:installation_log, :installation_id => installation.id)      
      get 'new', :installation_id => installation.id
      response.should be_success
    end
    
    it "should be successful for coo" do
      session[:coo] = true
      installation = Factory(:installation)
      log = Factory.attributes_for(:installation_log, :installation_id => installation.id)      
      get 'new', :installation_id => installation.id
      response.should be_success
    end    
    
    it "should reject those without rights" do
      installation = Factory(:installation)
      log = Factory.attributes_for(:installation_log, :installation_id => installation.id)      
      get 'new', :installation_id => installation.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
  end

  describe "'create'" do
    it "should be successful for comp_sec" do
      session[:comp_sec] = true
      installation = Factory(:installation)
      log = Factory.attributes_for(:installation_log, :installation_id => installation.id)      
      get 'create', :installation_id => installation.id, :installation_log => log
      response.should redirect_to installation_path(installation)
    end
    
    it "should increase the installation log count by one for a successful create" do
      session[:ceo] = true
      installation = Factory(:installation)
      log = Factory.attributes_for(:installation_log, :installation_id => installation.id)  
      lambda do    
        get 'create', :installation_id => installation.id, :installation_log => log
      end.should change(InstallationLog, :count).by(1)
    end
        
  end


end
