# encoding: utf-8
require 'spec_helper'

describe ManufacturersController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views  

  describe "'index'" do
    it "should be successful for all" do
      u = Factory(:user)
      mfg = Factory(:manufacturer, :input_by_id => u.id)
      get 'index'
      response.should be_success
    end
  end

  describe "'new'" do
    
    it "should reject those without rights" do  
      get 'new'
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end 
        
    it "should be successful for pur eng" do
      session[:pur_eng] = true
      get 'new'
      response.should be_success
    end

  end

  describe "'create'" do

    it "should be successful for a vp eng" do
      session[:vp_eng] = true
      mfg = Factory.attributes_for(:manufacturer)
      get 'create', :manufacturer => mfg
      response.should redirect_to URI.escape("/view_handler?index=0&msg=制造商已保存！")
    end    
    
    it "should increase count by 1 for a successful create" do
      session[:pur_eng] = true
      session[:user_id] = 1
      mfg = Factory.attributes_for(:manufacturer)
      lambda do
        get 'create', :manufacturer => mfg  
      end.should change(Manufacturer, :count).by(1)    
    end
    
    it "should reject those without rights" do  
      get 'create'
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end 
        
  end

  describe "'edit'" do
    it "should reject those without rights" do
      mfg = Factory(:manufacturer)
      get 'edit', :id => mfg.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should be successful for pur eng" do
      session[:pur_eng] = true
      mfg = Factory(:manufacturer)
      get 'edit', :id => mfg.id, :manufacturer => {:name => "name changed"}
      response.should be_success
    end
    
    it "should be successful for vp eng " do
      session[:vp_eng] = true      
      mfg = Factory(:manufacturer)
      get 'edit', :id => mfg.id, :manufacturer => {:name => "name changed"}
      response.should be_success
    end
        

  end

  describe "'update'" do
    it "should be successful for pur eng" do
      session[:pur_eng] = true
      mfg = Factory(:manufacturer)
      get 'update', :id => mfg.id, :manufacturer => {:address => "address changed"}
      response.should redirect_to URI.escape("/view_handler?index=0&mfg=已更新制造商信息！")
    end
    
    it "should reject nil name update" do
      session[:pur_eng] = true
      mfg = Factory(:manufacturer)
      get 'update', :id => mfg.id, :manufacturer => {:name => nil}      
      flash.now[:error].should == "无法更新制造商信息！"
      response.should render_template("edit")
    end
    
  end

end
