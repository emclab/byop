# encoding: utf-8
require 'spec_helper'

describe ProjectLogsController do

  before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "GET 'new'" do
    it "should be successful for comp_sec" do
      session[:comp_sec] = true
      project = FactoryGirl.create(:project)
      log = FactoryGirl.attributes_for(:project_log, :project_id => project.id)      
      get 'new', :project_id => project.id
      response.should be_success
    end
    
    it "should be successful for coo" do
      session[:coo] = true
      project = FactoryGirl.create(:project)
      log = FactoryGirl.attributes_for(:project_log, :project_id => project.id)      
      get 'new', :project_id => project.id
      response.should be_success
    end    
    
    it "should reject those without rights" do
      project = FactoryGirl.create(:project)
      log = FactoryGirl.attributes_for(:project_log, :project_id => project.id)      
      get 'new', :project_id => project.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")      
    end
    
  end

  describe "'create'" do
    it "should be successful for comp_sec" do
      session[:comp_sec] = true
      project = FactoryGirl.create(:project)
      log = FactoryGirl.attributes_for(:project_log, :project_id => project.id)      
      get 'create', :project_id => project.id, :project_log => log
      response.should redirect_to project_path(project)
    end
    
    it "should increase the project log count by one for a successful create" do
      session[:ceo] = true
      project = FactoryGirl.create(:project)
      log = FactoryGirl.attributes_for(:project_log, :project_id => project.id)  
      lambda do    
        get 'create', :project_id => project.id, :project_log => log
      end.should change(ProjectLog, :count).by(1)
    end
        
  end

  describe "GET 'show'" do
    it "should be successful for comp sec" do
      session[:comp_sec] = true
      project = FactoryGirl.create(:project)
      user = FactoryGirl.create(:user)
      log = FactoryGirl.create(:project_log, :project_id => project.id, :input_by_id => user.id)         
      get 'show', :project_id => project.id, :id => log.id
      response.should be_success
    end
  end

  describe "'destroy'" do
    it "should reject those with insufficient rights" do
      project = FactoryGirl.create(:project)
      user = FactoryGirl.create(:user)
      log = FactoryGirl.create(:project_log, :project_id => project.id, :input_by_id => user.id)        
      get 'destroy', :project_id => project.id, :id => log.id
      flash.now[:error].should == "权限不足！"
    end
    
    it "should destroy for comp_sec" do
      session[:comp_sec] = true
      project = FactoryGirl.create(:project)
      user = FactoryGirl.create(:user)
      log = FactoryGirl.create(:project_log, :project_id => project.id, :input_by_id => user.id)        
      get 'destroy', :project_id => project.id, :id => log.id
      response.should redirect_to project_path(project)      
    end
    
    it "should reduced project log count by 1 after a successful delete" do
      session[:vp_sales] = true
      project = FactoryGirl.create(:project)
      user = FactoryGirl.create(:user)
      log = FactoryGirl.create(:project_log, :project_id => project.id, :input_by_id => user.id)
      lambda do        
        get 'destroy', :project_id => project.id, :id => log.id 
      end.should change(ProjectLog, :count).by(-1)     
    end
  end
end
