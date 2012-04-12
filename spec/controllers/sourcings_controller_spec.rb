# encoding: utf-8
require 'spec_helper'

describe SourcingsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for eng" do
      session[:hydr_eng] = true
      proj = Factory(:project)
      src = Factory(:sourcing, :project_id => proj.id)
      get 'index', :project_id => proj.id
      response.should be_success
    end
    
    it "should OK for mech eng" do
      proj = Factory(:project)
      src = Factory(:sourcing, :project_id => proj.id)
      session[:mech_eng] = true
      get 'index', :project_id => proj.id
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      proj = Factory(:project)
      src = Factory.attributes_for(:sourcing, :project_id => proj.id)
      get 'new', :project_id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow vp eng" do
      proj = Factory(:project)
      src = Factory.attributes_for(:sourcing, :project_id => proj.id)
      session[:vp_eng] = true
      get 'new', :project_id => proj.id
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      proj = Factory(:project)
      src = Factory.attributes_for(:sourcing, :project_id => proj.id)
      get 'create', :project_id => proj.id, :sourcing => src
      response.should be_success
    end
    
    it "should OK for vp_eng and increase record count by 1 " do
      session[:vp_eng] = true
      u = Factory(:user)
      proj = Factory(:project)
      src = Factory.attributes_for(:sourcing, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :sourcing => src
        response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已保存！")
      end.should change(Sourcing, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:ceo] = true
      u = Factory(:user)
      proj = Factory(:project)
      src = Factory.attributes_for(:sourcing, :prod_name => nil, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :sourcing => src
        response.should render_template('new')
      end.should change(Sourcing, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      proj = Factory(:project)
      src = Factory(:sourcing, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => src.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp eng" do
      proj = Factory(:project)
      session[:vp_eng] = true
      u = Factory(:user)
      src = Factory(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => src.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      proj = Factory(:project)
      session[:ceo] = true
      u = Factory(:user)
      src = Factory(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => src.id, :sourcing => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      proj = Factory(:project)
      session[:vp_eng] = true
      u = Factory(:user)
      src = Factory(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => src.id, :sourcing => {:start_date => nil}
      response.should render_template('edit')
    end
    
    it "should update approved_by_vp_eng" do
      proj = Factory(:project)
      session[:vp_eng] = true
      u = Factory(:user)
      src = Factory(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_vp_eng => true}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
    end    
        
  end

  describe "approve" do
    it "should nothing happens for those without rights" do
      proj = Factory(:project)
      u = Factory(:user)
      session[:user_id] = u.id
      src= Factory(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => false)
      put 'approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_vp_eng => true}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足!")
    end
    
    it "should approve for vp_eng" do
      session[:vp_eng] = true
      session[:ceo] = false
      proj = Factory(:project)
      u = Factory(:user)
      session[:user_id] = u.id
      src = Factory(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => false)
      get 'approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_vp_eng => true, :approve_vp_eng_id => session[:user_id],
                                                                          :approve_date_vp_eng => Time.now }
      src.reload.approved_by_vp_eng.should == true
      src.reload.approve_vp_eng_id.should == session[:user_id]
      src.reload.approve_date_vp_eng.strftime("%Y/%m/%d").should == Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_sourcing_path(proj, src)      
    end
    
    it "should approve for ceo" do
      session[:ceo] = true
      proj = Factory(:project)
      u = Factory(:user)
      session[:user_id] = u.id
      src = Factory(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => true)
      get 'approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                                                          :approve_date_ceo => Time.now }
      src.reload.approved_by_ceo.should == true
      src.reload.approve_ceo_id.should == session[:user_id]
      src.reload.approve_date_ceo.strftime("%Y/%m/%d").should == Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_sourcing_path(proj, src)      
    end    
    
  end
  
  describe "dis_apporve" do
    it "should dis_approve for vp_eng" do
      session[:vp_eng] = true
      session[:ceo] = false
      proj = Factory(:project)
      u = Factory(:user)
      session[:user_id] = u.id
      src = Factory(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => false)
      get 'dis_approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_vp_eng => false, :approve_vp_eng_id => session[:user_id],
                                                                          :approve_date_vp_eng => Time.now }
      src.reload.approved_by_vp_eng.should == false
      src.reload.approve_vp_eng_id.should == session[:user_id]
      src.reload.approve_date_vp_eng.strftime("%Y/%m/%d").should == Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_sourcing_path(proj, src)      
    end
    
    it "should dis_approve for ceo" do
      session[:ceo] = true
      proj = Factory(:project)
      u = Factory(:user)
      session[:user_id] = u.id
      src = Factory(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => true)
      get 'dis_approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_ceo => false, :approve_ceo_id => session[:user_id],
                                                                          :approve_date_ceo => Time.now }
      src.reload.approved_by_ceo.should == false
      src.reload.approve_ceo_id.should == session[:user_id]
      src.reload.approve_date_ceo.strftime("%Y/%m/%d").should == Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_sourcing_path(proj, src)      
    end        
  end
  
  describe "re_approve by ceo" do
    it "should re_approve for ceo" do
      session[:ceo] = true
      proj = Factory(:project)
      u = Factory(:user)
      session[:user_id] = u.id
      src = Factory(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => true)
      get 're_approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_ceo => nil, :approve_ceo_id => nil, :approve_date_ceo => nil,
                                                                              :approved_by_vp_eng => nil, :approve_vp_eng_id => nil, :approve_date_vp_eng => nil }
      src.reload.approved_by_ceo.should == nil
      src.reload.approve_ceo_id.should == nil
      src.reload.approve_date_ceo.should == nil
      src.reload.approved_by_vp_eng.should == nil
      src.reload.approve_vp_eng_id.should == nil
      src.reload.approve_date_vp_eng.should == nil      
      response.should redirect_to project_sourcing_path(proj, src)      
    end            
  end

  describe "GET 'show'" do
    it "should reject those without right" do
      u = Factory(:user)
      proj = Factory(:project)
      src = Factory(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'show', :project_id => proj.id, :id => src.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      proj = Factory(:project)
      session[:elec_eng] = true
      u = Factory(:user)
      src = Factory(:sourcing, :input_by_id => u.id, :project_id => proj.id, :eng_id => u.id)
      get 'show', :project_id => proj.id, :id => src.id
      response.should be_success
    end
  end

end
