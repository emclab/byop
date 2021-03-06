# encoding: utf-8
require 'spec_helper'

describe UsersController do
  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
    controller.should_receive(:require_admin)
  end
  
  render_views
  
  describe "'index'" do
    it "returns http success" do 
      u = FactoryGirl.create(:user)    
      get 'index'
      response.should be_success
    end
  end

  describe "'show'" do
    it "returns http success" do
      u0 = FactoryGirl.create(:user, :email => nil)
      u = FactoryGirl.create(:user, :login => 'newlogin', :name => 'new', :input_by_id => u0.id)
      ul = FactoryGirl.create(:user_level, :user_id => u.id)
      get 'show', :id => u.id
      response.should be_success
    end
  end

  describe "'new'" do
    it "returns http success" do
      u = FactoryGirl.build(:user)
      ul = FactoryGirl.build(:user_level, :user_id => u.id)
      get 'new'
      response.should be_success
    end
  end

  describe "'create'" do
    it "returns http success with a valid input and increase the user count by 1" do
      session[:user_id] = 1
      u = FactoryGirl.attributes_for(:user, :user_levels_attributes => { '1' => {:position => 'mech_eng'}})
      lambda do
        get 'create', :user => u
        response.should redirect_to URI.escape("/view_handler?index=0&msg=用户已保存！")
      end.should change(User, :count).by(1)
    end
    
    it "returns http success with a valid user level input and increase the user level count by 1" do
      session[:user_id] = 1
      u = FactoryGirl.attributes_for(:user, :user_levels_attributes => { '1' => {:position => 'mech_eng'}})
      lambda do
        get 'create', :user => u
        response.should redirect_to URI.escape("/view_handler?index=0&msg=用户已保存！")
      end.should change(UserLevel, :count).by(1)
    end    
  end

  describe "'edit'" do
    it "returns http success with a valid user" do
      u = FactoryGirl.create(:user)
      get 'edit', :id => u.id
      response.should be_success
    end
  end

  describe "'update'" do
    it "returns success with a valid update" do
      u = FactoryGirl.create(:user)      
      ul = FactoryGirl.create(:user_level, :user_id => u.id)
      session[:user_id] = 1
      get 'update', :id => u.id, :user => {:name => 'a new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=更改已保存！")
    end
    
    it "would be OK to update the user level" do
      u = FactoryGirl.create(:user)      
      ul = FactoryGirl.create(:user_level, :user_id => u.id)
      session[:user_id] = 1
      get 'update', :id => u.id, :user => {:user_levels_attributes => { '0' => {:position => 'a new name'}}}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=更改已保存！")
    end    
  end

end
