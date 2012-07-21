# encoding: utf-8
require 'spec_helper'

describe ProductionsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for eng" do
      session[:hydr_eng] = true
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      prod = FactoryGirl.create(:production, :project_id => proj.id, :eng_id => u.id)
      get 'index', :project_id => proj.id
      response.should be_success
    end
    
    it "should OK for mech eng" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      prod = FactoryGirl.create(:production, :project_id => proj.id, :eng_id => u.id)
      session[:mech_eng] = true
      get 'index', :project_id => proj.id
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      proj = FactoryGirl.create(:project)
      prod = FactoryGirl.attributes_for(:production, :project_id => proj.id)
      get 'new', :project_id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow vp eng" do
      proj = FactoryGirl.create(:project)
      prod = FactoryGirl.attributes_for(:production, :project_id => proj.id)
      session[:vp_eng] = true
      get 'new', :project_id => proj.id
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      proj = FactoryGirl.create(:project)
      prod = FactoryGirl.attributes_for(:production, :project_id => proj.id)
      get 'create', :project_id => proj.id, :production => prod
      response.should be_success
    end
    
    it "should OK for vp_eng and increase record count by 1 " do
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      prod = FactoryGirl.attributes_for(:production, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :production => prod
        response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已保存！")
      end.should change(Production, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      prod = FactoryGirl.attributes_for(:production, :name => nil, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :production => prod
        response.should render_template('new')
      end.should change(Production, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      proj = FactoryGirl.create(:project)
      prod = FactoryGirl.create(:production, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => prod.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp eng" do
      proj = FactoryGirl.create(:project)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      prod = FactoryGirl.create(:production, :input_by_id => u.id, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => prod.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      proj = FactoryGirl.create(:project)
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      prod = FactoryGirl.create(:production, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => prod.id, :production => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      proj = FactoryGirl.create(:project)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      prod = FactoryGirl.create(:production, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => prod.id, :production => {:start_date => nil}
      response.should render_template('edit')
    end
        
  end

  describe "GET 'show'" do
    it "should reject those without right" do
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      prod = FactoryGirl.create(:production, :input_by_id => u.id, :project_id => proj.id)
      get 'show', :project_id => proj.id, :id => prod.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      proj = FactoryGirl.create(:project)
      session[:elec_eng] = true
      u = FactoryGirl.create(:user)
      prod = FactoryGirl.create(:production, :input_by_id => u.id, :project_id => proj.id)
      get 'show', :project_id => proj.id, :id => prod.id
      response.should be_success
    end
  end
end
