# encoding: utf-8
require 'spec_helper'

describe QualityIssuesController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "GET 'index'" do
    it "returns http success for hydr eng" do
      session[:hydr_eng] = true
      u = Factory(:user)
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory(:quality_issue, :project_id => proj.id, :report_by_id => u.id)
      get 'index', :project_id => proj.id
      response.should be_success
    end
    
    it "should OK for mech eng" do
      cust = Factory(:customer)
      u = Factory(:user)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory(:quality_issue, :project_id => proj.id, :report_by_id => u.id)
      session[:mech_eng] = true
      get 'index', :project_id => proj.id
      response.should be_success      
    end
  end

  describe "GET 'new'" do
    it "reject those without rights" do
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory.attributes_for(:quality_issue, :project_id => proj.id)
      get 'new', :project_id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow vp eng" do
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory.attributes_for(:quality_issue, :project_id => proj.id)
      session[:vp_eng] = true
      get 'new', :project_id => proj.id
      response.should be_success
    end
    
    it "should allow mech eng" do
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory.attributes_for(:quality_issue, :project_id => proj.id)
      session[:mech_eng] = true
      get 'new', :project_id => proj.id
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "reject those without right" do
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory.attributes_for(:quality_issue, :project_id => proj.id)
      get 'create', :project_id => proj.id, :quality_issue => qi
      response.should be_success
    end
    
    it "should OK for install_eng and increase record count by 1 " do
      session[:inst_eng] = true
      u = Factory(:user)
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory.attributes_for(:quality_issue, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :quality_issue => qi
        response.should redirect_to URI.escape("/view_handler?index=0&msg=质量问题已保存！")
      end.should change(QualityIssue, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:vp_eng] = true
      cust = Factory(:customer)
      u = Factory(:user)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory.attributes_for(:quality_issue, :name => nil, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :quality_issue => qi
        response.should render_template('new')
      end.should change(QualityIssue, :count).by(0)
    end      
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      production = Factory(:production)
      inst = Factory(:installation)
      src = Factory(:sourcing)
      pur = Factory(:purchasing)     
      cust = Factory(:customer)      
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory(:quality_issue, :project_id => proj.id, :production_id => production.id, :installation_id => inst.id,
                     :sourcing_id => src.id, :purchasing_id => pur.id)
      get 'edit', :project_id => proj.id, :id => qi.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp eng" do
      production = Factory(:production)
      inst = Factory(:installation)
      src = Factory(:sourcing)
      pur = Factory(:purchasing)     
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      session[:vp_eng] = true
      u = Factory(:user)
      qi = Factory(:quality_issue, :input_by_id => u.id, :project_id => proj.id, :production_id => production.id)
      get 'edit', :project_id => proj.id, :id => qi.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      production = Factory(:production)
      inst = Factory(:installation)
      src = Factory(:sourcing)
      pur = Factory(:purchasing)
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      session[:vp_eng] = true
      u = Factory(:user)
      qi = Factory(:quality_issue, :input_by_id => u.id, :project_id => proj.id, :production_id => production.id, :installation_id => inst.id,
                     :sourcing_id => src.id, :purchasing_id => pur.id)
      get 'update', :project_id => proj.id, :id => qi.id, :quality_issue => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=质量问题已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      installation = Factory(:installation)  
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      session[:ceo] = true
      u = Factory(:user)
      qi = Factory(:quality_issue, :input_by_id => u.id, :project_id => proj.id, :installation_id => installation.id)
      get 'update', :project_id => proj.id, :id => qi.id, :quality_issue => {:report_date => nil}
      response.should render_template('edit')
    end
  end

  describe "GET 'show'" do
    it "should reject those without right" do
      u = Factory(:user)
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      qi = Factory(:quality_issue, :input_by_id => u.id, :project_id => proj.id, :report_by_id => u.id)
      get 'show', :project_id => proj.id, :id => qi.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      cust = Factory(:customer)
      proj = Factory(:project, :customer_id => cust.id)
      session[:elec_eng] = true
      u = Factory(:user)
      qi = Factory(:quality_issue, :input_by_id => u.id, :project_id => proj.id, :report_by_id => u.id)
      get 'show', :project_id => proj.id, :id => qi.id
      response.should be_success
    end
  end

end
