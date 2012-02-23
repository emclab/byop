# encoding: utf-8

require 'spec_helper'

describe ProductionLogsController do

  before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "index" do
    it "should allow for index" do
      u = Factory(:user)
      production = Factory(:production, :input_by_id => u.id)
      get 'index', :production_id => production.id
      response.should be_success
    end
  end
  
  describe "GET 'new'" do
    it "should be successful for comp_sec" do
      session[:mech_eng] = true
      production = Factory(:production)
      log = Factory.attributes_for(:production_log, :production_id => production.id)      
      get 'new', :production_id => production.id
      response.should be_success
    end
    
    it "should be successful for coo" do
      session[:coo] = true
      production = Factory(:production)
      log = Factory.attributes_for(:production_log, :production_id => production.id)      
      get 'new', :production_id => production.id
      response.should be_success
    end    
    
    it "should reject those without rights" do
      production = Factory(:production)
      log = Factory.attributes_for(:production_log, :production_id => production.id)      
      get 'new', :production_id => production.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
  end

  describe "'create'" do
    it "should be successful for comp_sec" do
      session[:comp_sec] = true
      production = Factory(:production)
      log = Factory.attributes_for(:production_log, :production_id => production.id)      
      get 'create', :production_id => production.id, :production_log => log
      response.should redirect_to production_path(production)
    end
    
    it "should increase the production log count by one for a successful create" do
      session[:ceo] = true
      production = Factory(:production)
      log = Factory.attributes_for(:production_log, :production_id => production.id)  
      lambda do    
        get 'create', :production_id => production.id, :production_log => log
      end.should change(ProductionLog, :count).by(1)
    end
        
  end

end
