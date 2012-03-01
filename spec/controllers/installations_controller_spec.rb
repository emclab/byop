# encoding: utf-8
require 'spec_helper'

describe InstallationsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for eng" do
      u = Factory(:user)
      session[:hydr_eng] = true
      proj = Factory(:project)
      inst = Factory(:installation, :project_id => proj.id, :inst_eng_id => u.id)
      get 'index', :project_id => proj.id
      response.should be_success
    end
    
    it "should OK for mech eng" do
      u = Factory(:user)
      proj = Factory(:project)
      inst = Factory(:installation, :project_id => proj.id, :inst_eng_id => u.id)
      session[:mech_eng] = true
      get 'index', :project_id => proj.id
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      proj = Factory(:project)
      inst = Factory.attributes_for(:installation, :project_id => proj.id)
      get 'new', :project_id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow vp eng" do
      proj = Factory(:project)
      inst = Factory.attributes_for(:installation, :project_id => proj.id)
      session[:vp_eng] = true
      get 'new', :project_id => proj.id
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      proj = Factory(:project)
      inst = Factory.attributes_for(:installation, :project_id => proj.id)
      get 'create', :project_id => proj.id, :installation => inst
      response.should be_success
    end
    
    it "should OK for vp_eng and increase record count by 1 " do
      session[:vp_eng] = true
      u = Factory(:user)
      proj = Factory(:project)
      inst = Factory.attributes_for(:installation, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :installation => inst
        response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已保存！")
      end.should change(Installation, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:ceo] = true
      u = Factory(:user)
      proj = Factory(:project)
      inst = Factory.attributes_for(:installation, :install_name => nil, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :installation => inst
        response.should render_template('new')
      end.should change(Installation, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      proj = Factory(:project)
      inst = Factory(:installation, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => inst.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp eng" do
      proj = Factory(:project)
      session[:vp_eng] = true
      u = Factory(:user)
      inst = Factory(:installation, :input_by_id => u.id, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => inst.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      proj = Factory(:project)
      session[:ceo] = true
      u = Factory(:user)
      inst = Factory(:installation, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => inst.id, :installation => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      proj = Factory(:project)
      session[:vp_eng] = true
      u = Factory(:user)
      inst = Factory(:installation, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => inst.id, :installation => {:start_date => nil}
      response.should render_template('edit')
    end
        
  end

end
