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
    it "be OK for acct for sourcing" do
      session[:acct] = true
      s = FactoryGirl.create(:sourcing)
      p = FactoryGirl.create(:payment_log, :sourcing_id => s.id, :purchasing_id => nil) 
      get 'update', :id => p.id, :payment_log => {:amount => 123, :short_note => 'blabla'}, :sourcing_id => s.id  #:sourcing_id is for the load_sourcing before filter
      response.should redirect_to sourcing_payment_logs_path(s)  
    end
   
    it "be OK for ceo for purchasing" do
      session[:ceo] = true
      pur = FactoryGirl.create(:purchasing)
      p = FactoryGirl.create(:payment_log, :sourcing_id => nil, :purchasing_id => pur.id) 
      get 'update', :id => p.id, :payment_log => {:amount => 123, :short_note => 'yyblabla'}, :purchasing_id => pur.id  #:purchasing_id is for the load_sourcing before filter
      response.should redirect_to purchasing_payment_logs_path(pur)  
    end    
    
    it "not OK for nobody" do
      s = FactoryGirl.create(:sourcing)
      p = FactoryGirl.create(:payment_log, :sourcing_id => s.id)   
      get 'update', :id => p.id, :payment_log => {:amount => 123}
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")     
    end
    
  end
  
  describe "show" do
    it "should show payment log for acct" do
      session[:acct] = true
      u = FactoryGirl.create(:user)      
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.create(:purchasing, :project_id => proj.id)
      p = FactoryGirl.create(:payment_log, :sourcing_id => nil, :purchasing_id => pur.id, :input_by_id => u.id) 
      get 'show', :id => p.id
      response.should be_success
    end
  end
  
  describe "approve" do
    it "should be approved by ceo" do
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => src.id, :purchasing_id => nil, :approved_by_ceo => false)
      get 'approve', :id => pay.id
      pay.reload.approved_by_ceo.should eq true
    end  
  end
  
  describe "stamp_paid" do
    it "should be stamped by acct" do
      session[:acct] = true
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.create(:purchasing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => nil, :purchasing_id => pur.id, :paid => false)
      get 'stamp_paid', :id => pay.id
      pay.reload.paid.should eq true      
    end
  end
  
  describe "search" do
    it "should allow vp_eng to search sourcing" do
      session[:vp_eng] = true
      proj = FactoryGirl.create(:project) 
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => src.id, :purchasing_id => nil) 
      #p_search = FactoryGirl.attributes_for(:payment_log, :project_id_search => proj.id)
      get 'search_results', :payment_log => {:project_id_search => proj.id, :for_search => '外协'}
      response.should be_success      
    end

    it "should allow vp_eng to search purchasing" do
      session[:vp_eng] = true
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => src.id, :purchasing_id => nil)
      #p_search = FactoryGirl.attributes_for(:payment_log, :project_id_search => proj.id)
      get 'search_results', :payment_log => {:project_id_search => proj.id, :for_search => '外购'}
      response.should be_success
    end

    it "should pull payment logs between dates" do
      session[:acct] = true
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      pur = FactoryGirl.create(:purchasing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => src.id, :purchasing_id => nil, :pay_date => '2012-2-10')
      pay1 = FactoryGirl.create(:payment_log, :sourcing_id => nil, :purchasing_id => pur.id, :pay_date => '2012-2-19')
      pay2 = FactoryGirl.create(:payment_log, :sourcing_id => nil, :purchasing_id => pur.id, :pay_date => '2012-3-19')
      get 'search_results', :payment_log => {:end_date_search => '2012-03-01', :start_date_search => '2012-02-01'}
      assigns(:payment_logs).include?(pay).should be_true
      assigns(:payment_logs).include?(pay1).should be_true
      assigns(:payment_logs).should eq([pay1,pay])
      assigns(:payment_logs).include?(pay2).should be_false

    end

    it "should only pickup payment logs for the project " do
      session[:ceo] = true
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      pur = FactoryGirl.create(:purchasing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => src.id, :purchasing_id => nil, :pay_date => '2012-2-10')
      get 'search_results', :payment_log => {:project_id_search => proj.id}
      assigns(:payment_logs).should eq([pay])
    end

  end
  
  describe "stats" do

    it "should allow ceo to pull stats for neither sourcing or purchasing" do
      session[:ceo] = true
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => src.id, :purchasing_id => nil)
      #p_search = FactoryGirl.attributes_for(:payment_log, :project_id_search => proj.id)
      get 'stats_results', :payment_log => {:project_id_search => proj.id, :for_search => ''}
      response.should be_success
    end

    it "should allow ceo to pull stats for sourcing" do
      session[:ceo] = true
      proj = FactoryGirl.create(:project) 
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => src.id, :purchasing_id => nil) 
      #p_search = FactoryGirl.attributes_for(:payment_log, :project_id_search => proj.id)
      get 'stats_results', :payment_log => {:project_id_search => proj.id, :for_search => '外协'}
      response.should be_success
    end

    it "should allow ceo to pull stats for purchasing" do
      session[:ceo] = true
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      pay = FactoryGirl.create(:payment_log, :sourcing_id => src.id, :purchasing_id => nil)
      #p_search = FactoryGirl.attributes_for(:payment_log, :project_id_search => proj.id)
      get 'stats_results', :payment_log => {:project_id_search => proj.id, :for_search => '外购'}
      response.should be_success
    end

  end

end
