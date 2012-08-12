# encoding: utf-8
require 'spec_helper'

describe SourcingLogsController do

  before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "index" do
    it "should allow for index" do
      u = FactoryGirl.create(:user)
      sourcing = FactoryGirl.create(:sourcing, :input_by_id => u.id)
      get 'index', :sourcing_id => sourcing.id
      response.should be_success
    end
  end
  
  describe "GET 'new'" do
    it "should be successful for mech eng" do
      session[:mech_eng] = true
      sourcing = FactoryGirl.create(:sourcing)
      log = FactoryGirl.attributes_for(:sourcing_log, :sourcing_id => sourcing.id)      
      get 'new', :sourcing_id => sourcing.id
      response.should be_success
    end
    
    it "should be successful for coo" do
      session[:coo] = true
      sourcing = FactoryGirl.create(:sourcing)
      log = FactoryGirl.attributes_for(:sourcing_log, :sourcing_id => sourcing.id)      
      get 'new', :sourcing_id => sourcing.id
      response.should be_success
    end    
    
    it "should reject those without rights" do
      sourcing = FactoryGirl.create(:sourcing)
      log = FactoryGirl.attributes_for(:sourcing_log, :sourcing_id => sourcing.id)      
      get 'new', :sourcing_id => sourcing.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
  end

  describe "'create'" do
    it "should be successful for comp_sec" do
      session[:comp_sec] = true
      proj = FactoryGirl.create(:project)
      sourcing = FactoryGirl.create(:sourcing, :project_id => proj.id)
      log = FactoryGirl.attributes_for(:sourcing_log, :sourcing_id => sourcing.id)      
      get 'create', :sourcing_id => sourcing.id, :sourcing_log => log
      response.should redirect_to project_sourcing_path(sourcing.project, sourcing)
    end
    
    it "should increase the sourcing log count by one for a successful create" do
      session[:ceo] = true
      proj = FactoryGirl.create(:project)
      sourcing = FactoryGirl.create(:sourcing, :project_id => proj.id)
      log = FactoryGirl.attributes_for(:sourcing_log, :sourcing_id => sourcing.id)  
      lambda do    
        get 'create', :sourcing_id => sourcing.id, :sourcing_log => log
      end.should change(SourcingLog, :count).by(1)
    end
        
  end


end
