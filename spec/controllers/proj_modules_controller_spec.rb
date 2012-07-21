# encoding: utf-8
require 'spec_helper'

describe ProjModulesController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views  

  describe "'new'" do
    
    it "should reject those without rights" do
      proj = FactoryGirl.create(:project)  
      get 'new', :project_id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end 
        
    it "should be successful for vp eng" do
      session[:vp_eng] = true
      proj = FactoryGirl.create(:project)
      get 'new', :project_id => proj.id
      response.should be_success
    end

  end

  describe "'create'" do

    it "should be successful for a vp eng" do
      session[:vp_eng] = true
      proj = FactoryGirl.create(:project)
      sub = FactoryGirl.attributes_for(:proj_module, :project_id => proj.id)
      lambda do
        get 'create', :project_id => proj.id, :proj_module => sub
        response.should redirect_to project_path(proj)
      end.should change(ProjModule, :count).by(1)
    end    
    
    it "should redirect to new if data has error" do 
      session[:vp_eng] = true 
      proj = FactoryGirl.create(:project)
      sub = FactoryGirl.attributes_for(:proj_module, :project_id => proj.id, :name => nil)
      get 'create', :project_id => proj.id, :proj_module => sub
      flash[:error].should eq '无法保存！'
      response.should render_template('new')
    end 
        
  end

end
