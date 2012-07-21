# encoding: utf-8
require 'spec_helper'

describe OutLogsController do
  before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "GET 'new'" do
    it "should be successful for pur eng" do
      session[:pur_eng] = true
      part = FactoryGirl.create(:part)
      log = FactoryGirl.attributes_for(:out_log, :part_id => part.id)      
      get 'new', :part_id => part.id
      response.should be_success
    end
    
    it "should be successful for vp end" do
      session[:vp_eng] = true
      part = FactoryGirl.create(:part)
      log = FactoryGirl.attributes_for(:out_log, :part_id => part.id)      
      get 'new', :part_id => part.id
      response.should be_success
    end    
    
    it "should reject those without rights" do
      part = FactoryGirl.create(:part)
      log = FactoryGirl.attributes_for(:out_log, :part_id => part.id)   
      get 'new', :part_id => part.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
  end

  describe "GET 'create'" do
    it "should be successful for pur eng" do
      session[:pur_eng] = true
      part = FactoryGirl.create(:part)
      log = FactoryGirl.attributes_for(:out_log, :part_id => part.id)      
      get 'create', :part_id => part.id, :out_log => log
      response.should redirect_to part_path(part)
    end
    
    it "should increase the project log count by one for a successful create" do
      session[:ceo] = true
      part = FactoryGirl.create(:part)
      log = FactoryGirl.attributes_for(:out_log, :part_id => part.id)   
      lambda do    
        get 'create', :part_id => part.id, :out_log => log
      end.should change(OutLog, :count).by(1)
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      u = FactoryGirl.create(:user)
      project = FactoryGirl.create(:project)
      part = FactoryGirl.create(:part)
      log = FactoryGirl.create(:out_log, :part_id => part.id, :receiver_id => u.id, :project_id => project.id, :input_by_id => u.id)
      get 'show', :part_id => part.id, :id => log.id
      response.should be_success
    end
  end

end
