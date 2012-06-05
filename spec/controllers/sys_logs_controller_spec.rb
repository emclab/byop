# encoding: utf-8
require 'spec_helper'

describe SysLogsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
    #controller.should_receive(:session_timeout)
  end
    
  render_views
  
  describe "'index'" do
    it "should reject for those without right" do
      slog = FactoryGirl.create(:sys_log)
      get 'index'
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")     
    end
    
    it "should success for admin" do
      session[:admin] = true
      slog = FactoryGirl.create(:sys_log)
      get 'index'
      response.should be_success
    end
    
    it "should success for corp head" do
      session[:comp_sec] = true
      slog = FactoryGirl.create(:sys_log)
      get 'index'
      response.should be_success
    end    
  end
  
  describe "sort by user id" do
    it "should success for admin" do
      session[:admin] = true
      slog = FactoryGirl.create(:sys_log)
      get 'sort_by_user_id'
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=1&url=#{sys_logs_path}")      
    end
  end

  describe "sort by user ip" do
    it "should success for admin" do
      session[:ceo] = true
      slog = FactoryGirl.create(:sys_log)
      get 'sort_by_ip'
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=1&url=#{sys_logs_path}")     
    end
  end
  
end
