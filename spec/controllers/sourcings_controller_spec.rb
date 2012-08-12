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
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id, :src_eng_id => u.id)
      get 'index', :project_id => proj.id
      response.should be_success
    end
    
    it "should OK for mech eng" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id, :src_eng_id => u.id)
      session[:mech_eng] = true
      get 'index', :project_id => proj.id
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.attributes_for(:sourcing, :project_id => proj.id)
      get 'new', :project_id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow vp eng" do
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.attributes_for(:sourcing, :project_id => proj.id)
      session[:vp_eng] = true
      get 'new', :project_id => proj.id
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.attributes_for(:sourcing, :project_id => proj.id)
      get 'create', :project_id => proj.id, :sourcing => src
      response.should be_success
    end
    
    it "should OK for vp_eng and increase record count by 1 " do
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.attributes_for(:sourcing, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :sourcing => src
        response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已保存！")
      end.should change(Sourcing, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.attributes_for(:sourcing, :prod_name => nil, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :sourcing => src
        response.should render_template('new')
      end.should change(Sourcing, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => src.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp eng" do
      proj = FactoryGirl.create(:project)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => src.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      proj = FactoryGirl.create(:project)
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => src.id, :sourcing => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      proj = FactoryGirl.create(:project)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => src.id, :sourcing => {:start_date => nil}
      response.should render_template('edit')
    end
    
    it "should update approved_by_vp_eng" do
      proj = FactoryGirl.create(:project)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_vp_eng => true}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
    end    
        
  end

  describe "approve" do
    it "should nothing happens for those without rights" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      src= FactoryGirl.create(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => false, :project_id => proj.id)
      put 'approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_vp_eng => true}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足!")
    end
    
    it "should approve for vp_eng" do
      session[:vp_eng] = true
      session[:ceo] = false
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => false, :project_id => proj.id)
      get 'approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_vp_eng => true, :approve_vp_eng_id => session[:user_id],
                                                                          :approve_date_vp_eng => Time.now }
      src.reload.approved_by_vp_eng.should eq true
      src.reload.approve_vp_eng_id.should eq session[:user_id]
      src.reload.approve_date_vp_eng.strftime("%Y/%m/%d").should eq Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_sourcing_path(proj, src)      
    end
    
    it "should approve for ceo" do
      session[:ceo] = true
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => true, :project_id => proj.id)
      get 'approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                                                          :approve_date_ceo => Time.now }
      src.reload.approved_by_ceo.should eq true
      src.reload.approve_ceo_id.should eq session[:user_id]
      src.reload.approve_date_ceo.strftime("%Y/%m/%d").should eq Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_sourcing_path(proj, src)      
    end    
    
  end
  
  describe "dis_apporve" do
    it "should dis_approve for vp_eng" do
      session[:vp_eng] = true
      session[:ceo] = false
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => false, :project_id => proj.id)
      get 'dis_approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_vp_eng => false, :approve_vp_eng_id => session[:user_id],
                                                                          :approve_date_vp_eng => Time.now }
      src.reload.approved_by_vp_eng.should eq false
      src.reload.approve_vp_eng_id.should eq session[:user_id]
      src.reload.approve_date_vp_eng.strftime("%Y/%m/%d").should eq Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_sourcing_path(proj, src)      
    end
    
    it "should dis_approve for ceo" do
      session[:ceo] = true
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => true, :project_id => proj.id)
      get 'dis_approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_ceo => false, :approve_ceo_id => session[:user_id],
                                                                          :approve_date_ceo => Time.now }
      src.reload.approved_by_ceo.should eq false
      src.reload.approve_ceo_id.should eq session[:user_id]
      src.reload.approve_date_ceo.strftime("%Y/%m/%d").should eq Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_sourcing_path(proj, src)      
    end        
  end
  
  describe "re_approve by ceo" do
    it "should re_approve for ceo" do
      session[:ceo] = true
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => true, :project_id => proj.id)
      get 're_approve', :project_id => proj.id, :id => src.id, :sourcing => {:approved_by_ceo => nil, :approve_ceo_id => nil, :approve_date_ceo => nil,
                                                                              :approved_by_vp_eng => nil, :approve_vp_eng_id => nil, :approve_date_vp_eng => nil }
      src.reload.approved_by_ceo.should eq nil
      src.reload.approve_ceo_id.should eq nil
      src.reload.approve_date_ceo.should eq nil
      src.reload.approved_by_vp_eng.should eq nil
      src.reload.approve_vp_eng_id.should eq nil
      src.reload.approve_date_vp_eng.should eq nil      
      response.should redirect_to project_sourcing_path(proj, src)      
    end            
  end
  
  describe "stamp for comp_sec ONLY" do
    it "should stamp for comp_sec" do
      session[:comp_sec] = true
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => true, :project_id => proj.id)
      get "stamp", :project_id => proj.id, :id => src.id, :sourcing => { :stamp => true }
      response.should redirect_to project_sourcing_path(@project, @sourcing)
      src.reload.stamped.should eq true      
    end
    
    it "should not stamp for all others" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :approved_by_vp_eng => true, :project_id => proj.id)
      get "stamp", :project_id => proj.id, :id => src.id, :sourcing => { :stamp => true }
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!")       
    end
  end

  describe "GET 'show'" do
    it "should reject those without right" do
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :project_id => proj.id)
      get 'show', :project_id => proj.id, :id => src.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      proj = FactoryGirl.create(:project)
      session[:elec_eng] = true
      u = FactoryGirl.create(:user)
      src = FactoryGirl.create(:sourcing, :input_by_id => u.id, :project_id => proj.id, :eng_id => u.id)
      get 'show', :project_id => proj.id, :id => src.id
      response.should be_success
    end
  end

  describe "seach result" do
    it "should do search for coo" do
      session[:coo] = true
      eng = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      src = FactoryGirl.create(:sourcing, :project_id => proj.id, :eng_id => eng.id, :src_eng_id => nil)
      p_search = FactoryGirl.attributes_for(:sourcing)
      get 'search_results', :sourcing => p_search 
      response.should be_success
      assigns(:sourcings).should eq([src])
    end
  end
  
end
