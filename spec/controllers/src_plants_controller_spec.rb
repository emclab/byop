# encoding: utf-8
require 'spec_helper'

describe SrcPlantsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for anyone" do
      plant = Factory(:src_plant)
      get 'index'
      response.should be_success
    end
    
    it "should OK for src eng" do
      plant = Factory(:src_plant)
      session[:src_eng] = true
      get 'index'
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      plant = Factory.attributes_for(:src_plant)
      get 'new'
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow src eng" do
      plant = Factory.attributes_for(:src_plant)
      session[:src_eng] = true
      get 'new'
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      plant = Factory.attributes_for(:src_plant)
      get 'create'
      response.should be_success
    end
    
    it "should OK for src_eng and increase record count by 1 for src plant" do
      session[:src_eng] = true
      u = Factory(:user)
      plant = Factory.attributes_for(:src_plant, :input_by_id => u.id) 
      lambda do
        get 'create', :src_plant => plant
        response.should redirect_to URI.escape("/view_handler?index=0&msg=外协厂信息已保存！")
      end.should change(SrcPlant, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:src_eng] = true
      u = Factory(:user)
      plant = Factory.attributes_for(:src_plant, :name => nil, :input_by_id => u.id) 
      lambda do
        get 'create', :src_plant => plant
        response.should render_template('new')
      end.should change(SrcPlant, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      plant = Factory(:src_plant)
      get 'edit', :id => plant.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp_eng" do
      session[:vp_eng] = true
      u = Factory(:user)
      plant = Factory(:src_plant, :input_by_id => u.id)
      get 'edit', :id => plant.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      session[:ceo] = true
      u = Factory(:user)
      plant = Factory(:src_plant, :input_by_id => u.id)
      get 'update', :id => plant.id, :src_plant => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=外协厂信息已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      session[:src_eng] = true
      u = Factory(:user)
      plant = Factory(:src_plant, :input_by_id => u.id)
      get 'update', :id => plant.id, :src_plant => {:quality_system => nil}
      response.should render_template('edit')
    end
        
  end

  describe "GET 'show'" do
    it "should reject those without right" do
      u = Factory(:user)
      plant = Factory(:src_plant, :input_by_id => u.id)
      get 'show', :id => plant.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      session[:mech_eng] = true
      u = Factory(:user)
      plant = Factory(:src_plant, :input_by_id => u.id)
      get 'show', :id => plant.id
      response.should be_success
    end
  end

end
