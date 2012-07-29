# encoding: utf-8
require 'spec_helper'

describe PaymentLogsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "GET 'index'" do
    it "returns http success for those with right" do
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      pro = FactoryGirl.create(:project, :name => 'a name')
      pur = FactoryGirl.create(:purchasing, :project_id => pro.id)
      p = FactoryGirl.create(:payment_log, :purchasing_id => pur.id, :input_by_id => u.id)
      get 'index', :purchasing_id => pur.id
      response.should be_success
      assigns(:payment_logs).should eq([p])
    end
    
    it "should block those without right" do
      p = FactoryGirl.create(:payment_log, :purchasing_id => 1)
      get 'index'
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")       
    end
  end

  describe "GET 'new'" do
    it "OK with vp_eng" do
      session[:vp_eng] = true
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "OK for comp_sec to enter" do
      session[:comp_sec] = true
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      s = FactoryGirl.create(:sourcing)
      p = FactoryGirl.attributes_for(:payment_log, :sourcing_id => s.id)
      lambda do
        get 'create', :payment_log => p, :sourcing_id => s.id
        response.should redirect_to sourcing_payment_logs_path(s)
      end.should change(PaymentLog, :count).by(1)
    end
  end

  describe "GET 'edit'" do
    it "returns http success for vp_eng" do
      session[:vp_eng] = true
      s = FactoryGirl.create(:sourcing)
      p = FactoryGirl.create(:payment_log, :sourcing_id => s.id)      
      get 'edit', :id => p.id 
      response.should be_success
    end
    
    it "not OK for nobody" do
      s = FactoryGirl.create(:sourcing)
      p = FactoryGirl.create(:payment_log, :sourcing_id => s.id)      
      get 'edit', :id => p.id 
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end    
  end

  describe "GET 'update'" do
    it "be OK for acct" do
      session[:acct] = true
      s = FactoryGirl.create(:sourcing)
      p = FactoryGirl.create(:payment_log, :sourcing_id => s.id, :purchasing_id => nil)   
      get 'update', :id => p.id, :payment_log => {:amount => 123}
      response.should redirect_to sourcing_payment_logs_path(s)
    end
    
    it "not OK for nobody" do
      s = FactoryGirl.create(:sourcing)
      p = FactoryGirl.create(:payment_log, :sourcing_id => s.id)   
      get 'update', :id => p.id, :payment_log => {:amount => 123}
      response.should be_success      
    end
    
  end

end
