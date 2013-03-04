# encoding: utf-8
require 'spec_helper'

describe "LoginPages" do
  describe "GET /login_pages" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit '/signin'
      page.body.should have_content('用户名：')
    end
    
    it "should have title Login" do
      visit '/'
      page.body.should have_content('Login')
    end
    
    it "should login in with right user name and password" do
      user = FactoryGirl.create(:user, :login => 'test12', :password => 'password', :password_confirmation => 'password')
      lambda do
        visit '/'
        fill_in "login", :with => user.login
        fill_in "password", :with => 'password'
        click_button '登录'
        #page.body.should render_template("user_menus/index"). not for integration test
        page.body.should have_content("北冶")
      end.should change(Session, :count).by(1)
    end
    
  end
  
  describe "user page" do
    
    before(:each) do
      ul = FactoryGirl.build(:user_level, :position => 'admin')
      @user = FactoryGirl.create(:user, :login => 'test12', :password => 'password', :password_confirmation => 'password', :user_levels => [ul])
      visit '/'
      fill_in "login", :with => @user.login
      fill_in "password", :with => 'password'
      click_button '登录'  
    end

    it "should render new user page" do
      visit new_user_path
      save_and_open_page
      page.body.should have_content("北冶 | 输入用户")
    end  

    it "should have login field" do
      visit new_user_path
      page.body.should have_content("输入用户")
    end
    
    it "should have pasword field" do
      visit new_user_path
      page.body.should have_content("用户属性：")
    end  
                  
    it "should have new user link" do
      visit users_path
      page.body.should have_link("New User", :href => SUBURI + "/view_handler?index=1&url=#{new_user_path}")
    end  
      
  end
  
  describe 'user page - reject non admin' do
    it "should redirect to signin page for non-admin employee" do
      ul = FactoryGirl.build(:user_level, :position => 'non-admin')
      @user = FactoryGirl.create(:user, :login => 'test12', :password => 'password', :password_confirmation => 'password', :user_levels => [ul])
      visit '/'
      fill_in "login", :with => @user.login
      fill_in "password", :with => 'password'
      click_button '登录'
      visit users_path
      page.body.should have_content('Login') 
    end
    
    it "should redirect to signin page for admin but non employee" do
      ul = FactoryGirl.build(:user_level, :position => 'admin')
      @user = FactoryGirl.create(:user, :user_type => 'sub', :login => 'test12', :password => 'password', :password_confirmation => 'password', :user_levels => [ul])
      visit '/'
      fill_in "login", :with => @user.login
      fill_in "password", :with => 'password'
      click_button '登录'
      visit users_path
      page.body.should have_content('Login')
    end
  end
  
 # describe "purchasing page" do
   # before(:each) do
      #ul = FactoryGirl.build(:user_level, :position => 'mech_eng')
      #@user = FactoryGirl.create(:user, :login => 'test12', :password => 'password', :password_confirmation => 'password') #, :user_levels => [ul])
     # visit '/'
     # fill_in "login", :with => @user.login
     # fill_in "password", :with => 'password'
     # click_button '登录'  
   # end
    
   # it "should display the approve page", :js => true do
      #ul = FactoryGirl.build(:user_level, :position => 'mech_eng')
     # user = FactoryGirl.create(:user, :login => 'test12', :password => 'password', :password_confirmation => 'password') #, :user_levels => [ul])
     # visit '/'
     # fill_in "login", :with => user.login
     # fill_in "password", :with => 'password'
     # click_button '登录'  
     # proj = FactoryGirl.create(:project)
     # pur = FactoryGirl.create(:purchasing, :eng_id => user.id, :project_id => proj.id, :manufacturer_id => nil, :input_by_id => user.id, :approved_by_eng => nil)
     # visit project_purchasing_path(proj, pur)
     # page.body.should have_content("计划内容-" + pur.prod_name)
     # page.body.should have_link("批准采购", :href => "#{approve_project_purchasing_path(proj, pur)}")
     # click_link '批准采购'  # failed (see stackoverflow post on 3/1/2013) because of the javascript. use button_to will work with click_button. 
      #Someone suggests using capybara instead of webrate. Or force webrate to accept put instead of GET. 
      #page.body.should be_success
   # end
  #end
end
