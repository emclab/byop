# encoding: utf-8
require 'spec_helper'

describe PurchasingsController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for eng" do
      session[:hydr_eng] = true
      cust = FactoryGirl.create(:customer)
      proj = FactoryGirl.create(:project, :customer_id => cust.id)
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :project_id => proj.id, :pur_eng_id => u.id, :eng_id => u.id)
      get 'index', :project_id => proj.id
      response.should be_success
      assigns(:purchasings).should eq([pur])
    end
    
    it "should OK for mech eng" do
      cust = FactoryGirl.create(:customer)
      proj = FactoryGirl.create(:project, :customer_id => cust.id)
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :project_id => proj.id, :pur_eng_id => u.id)
      session[:mech_eng] = true
      get 'index', :project_id => proj.id
      response.should be_success 
      assigns(:purchasings).should eq([pur])    
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.attributes_for(:purchasing, :project_id => proj.id)
      get 'new', :project_id => proj.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow vp eng" do
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.attributes_for(:purchasing, :project_id => proj.id)
      session[:vp_eng] = true
      get 'new', :project_id => proj.id
      response.should be_success
    end
  end

  describe "'create'" do
    it "reject those without right" do
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.attributes_for(:purchasing, :project_id => proj.id)
      get 'create', :project_id => proj.id, :purchasing => pur
      response.should be_success
    end
    
    it "should OK for vp_eng and increase record count by 1 " do
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.attributes_for(:purchasing, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :purchasing => pur
        response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已保存！")
      end.should change(Purchasing, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.attributes_for(:purchasing, :prod_name => nil, :input_by_id => u.id, :project_id => proj.id) 
      lambda do
        get 'create', :project_id => proj.id, :purchasing => pur
        response.should render_template('new')
      end.should change(Purchasing, :count).by(0)
    end      
    
  end

  describe "GET 'edit'" do
    it "reject those without rights" do
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.create(:purchasing, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => pur.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp eng" do
      proj = FactoryGirl.create(:project)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 'edit', :project_id => proj.id, :id => pur.id
      response.should be_success
    end
  end

  describe "GET 'update'" do
    it "success for ceo" do
      proj = FactoryGirl.create(:project)
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => pur.id, :purchasing => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      proj = FactoryGirl.create(:project)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 'update', :project_id => proj.id, :id => pur.id, :purchasing => {:prod_name => nil}
      response.should render_template('edit')
    end
      
    it "should not update approved_by_eng while updating other fields" do
      proj = FactoryGirl.create(:project)
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id, :approved_by_eng => nil, :approved_by_ceo => nil, :approved_by_vp_eng => nil,
                               :approved_by_pur_eng => nil, :stamped => nil)
      get 'update', :project_id => proj.id, :id => pur.id, :purchasing => {:name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
      pur.reload.approved_by_ceo.should eq nil 
      pur.reload.approved_by_eng.should eq nil
      pur.reload.approved_by_pur_eng.should eq nil
      pur.reload.approved_by_vp_eng.should eq nil 
    end  
  end
  
  describe "destroy" do
    it "should destroy for vp_eng" do
      session[:vp_eng] = true
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 'destroy', :project_id => proj.id, :id => pur.id
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=计划已删除！")
    end
    
    it "should not allow without right" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 'destroy', :project_id => proj.id, :id => pur.id
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  describe "approve" do
    it "should nothing happens for those without rights" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      pur= FactoryGirl.create(:purchasing, :input_by_id => u.id, :approved_by_vp_eng => false, :project_id => proj.id)
      put 'approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_vp_eng => true}, :method => :put
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足!")
    end
    
   it "should approve for eng in charge" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:mech_eng] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :eng_id => u.id, :project_id => proj.id)
      get 'approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_eng => true, :approve_eng_id => session[:user_id],
                                                                          :approve_date_eng => Time.now }
      pur.reload.approved_by_eng.should be_true
      pur.reload.approve_eng_id.should eq session[:user_id]
      pur.reload.approve_date_eng.strftime("%Y/%m/%d").should eq Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_purchasing_path(proj, pur)      
    end    

   it "should approve for vp eng" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:vp_eng] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :approved_by_eng => true, :project_id => proj.id)
      get 'approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_vp_eng => true, :approve_vp_eng_id => session[:user_id],
                                                                          :approve_date_vp_eng => Time.now }
      response.should redirect_to project_purchasing_path(proj, pur) 
      pur.reload.approved_by_vp_eng.should eq true
      pur.reload.approve_vp_eng_id.should eq session[:user_id]
      pur.reload.approve_date_vp_eng.strftime("%Y/%m/%d").should == Time.now.utc.strftime("%Y/%m/%d")
           
    end    
        
   it "should approve for pur eng in charge" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:pur_eng] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :approved_by_eng => true, :approved_by_vp_eng => true, :project_id => proj.id)
      get 'approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_pur_eng => true, :approve_pur_eng_id => session[:user_id],
                                                                          :approve_date_pur_eng => Time.now }
      response.should redirect_to project_purchasing_path(proj, pur)  
      pur.reload.approved_by_pur_eng.should eq true
      pur.reload.approve_pur_eng_id.should eq session[:user_id]
      pur.reload.approve_date_pur_eng.strftime("%Y/%m/%d").should == Time.now.utc.strftime("%Y/%m/%d")
          
    end    

   it "should approve for ceo" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:ceo] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :approved_by_eng => true, :approved_by_pur_eng => true, :approved_by_vp_eng => true, :project_id => proj.id)
      get 'approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                                                          :approve_date_ceo => Time.now }
      response.should redirect_to project_purchasing_path(proj, pur)  
      pur.reload.approved_by_ceo.should eq true
      pur.reload.approve_ceo_id.should eq session[:user_id]
      pur.reload.approve_date_ceo.strftime("%Y/%m/%d").should == Time.now.utc.strftime("%Y/%m/%d")
    
    end    
        
  end
  
  describe "dis_approve" do
   it "should dis_approve for eng in charge" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:mech_eng] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :eng_id => u.id, :project_id => proj.id)
      get 'dis_approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_eng => false, :approve_eng_id => session[:user_id],
                                                                          :approve_date_eng => Time.now }
      pur.reload.approved_by_eng.should eq false
      pur.reload.approve_eng_id.should eq session[:user_id]
      pur.reload.approve_date_eng.strftime("%Y/%m/%d").should eq Time.now.utc.strftime("%Y/%m/%d")
      response.should redirect_to project_purchasing_path(proj, pur)      
    end    

   it "should dis_approve for vp eng" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:vp_eng] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :approved_by_eng => true, :project_id => proj.id)
      get 'dis_approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_vp_eng => false, :approve_vp_eng_id => session[:user_id],
                                                                          :approve_date_vp_eng => Time.now }
      response.should redirect_to project_purchasing_path(proj, pur) 
      pur.reload.approved_by_vp_eng.should eq false
      pur.reload.approve_vp_eng_id.should eq session[:user_id]
      pur.reload.approve_date_vp_eng.strftime("%Y/%m/%d").should eq Time.now.utc.strftime("%Y/%m/%d")
           
    end    
        
   it "should dis_approve for pur eng in charge" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:pur_eng] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :approved_by_eng => true, :approved_by_vp_eng => true, :project_id => proj.id)
      get 'dis_approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_pur_eng => false, :approve_pur_eng_id => session[:user_id],
                                                                          :approve_date_pur_eng => Time.now }
      response.should redirect_to project_purchasing_path(proj, pur)  
      pur.reload.approved_by_pur_eng.should eq false
      pur.reload.approve_pur_eng_id.should eq session[:user_id]
      pur.reload.approve_date_pur_eng.strftime("%Y/%m/%d").should eq Time.now.utc.strftime("%Y/%m/%d")
          
    end    

   it "should dis_approve for ceo" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:ceo] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :approved_by_eng => true, :approved_by_pur_eng => true, :approved_by_vp_eng => true, :project_id => proj.id)
      get 'dis_approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_ceo => false, :approve_ceo_id => session[:user_id],
                                                                          :approve_date_ceo => Time.now }
      response.should redirect_to project_purchasing_path(proj, pur)  
      pur.reload.approved_by_ceo.should eq false
      pur.reload.approve_ceo_id.should eq session[:user_id]
      pur.reload.approve_date_ceo.strftime("%Y/%m/%d").should == Time.now.utc.strftime("%Y/%m/%d")
    
    end        
  end
  
  describe "re_approve" do
    it "should allow ceo to re set the aprpove process" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:ceo] = true
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id)
      get 're_approve', :project_id => proj.id, :id => pur.id, :purchasing => {:approved_by_ceo => nil, :approve_ceo_id => nil, :approve_date_ceo => nil,
                                                                            :approved_by_pur_eng => nil, :approve_pur_eng_id => nil, :approve_date_pur_eng => nil,
                                                                            :approved_by_eng => nil, :approve_eng_id => nil, :approve_date_eng => nil, 
                                                                            :approved_by_vp_eng => nil, :approve_vp_eng_id => nil, :approve_date_vp_eng => nil   }
      response.should redirect_to project_purchasing_path(proj, pur)  
      pur.reload.approved_by_ceo.should eq nil 
      pur.reload.approved_by_eng.should eq nil
      pur.reload.approved_by_pur_eng.should eq nil
      pur.reload.approved_by_vp_eng.should eq nil     
    end
  end
  
  describe "stamp for comp_sec ONLY" do
    it "should stamp for comp_sec" do
      session[:comp_sec] = true
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id) 
      get 'stamp', :project_id => proj.id, :id => pur.id, :purchasing => {:stamped => true }  
      response.should redirect_to project_purchasing_path(proj, pur)
      pur.reload.stamped.should eq true   
    end
    
    it "should not allow to stamp for others" do
      proj = FactoryGirl.create(:project)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id) 
      get 'stamp', :project_id => proj.id, :id => pur.id, :purchasing => {:stamped => true } 
      response.should redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!")         
    end
  end
  
  describe "GET 'show'" do
    it "should reject those without right" do
      u = FactoryGirl.create(:user)
      proj = FactoryGirl.create(:project)
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id, :eng_id => u.id)
      get 'show', :project_id => proj.id, :id => pur.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      m = FactoryGirl.create(:manufacturer)
      proj = FactoryGirl.create(:project)
      session[:elec_eng] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:purchasing, :input_by_id => u.id, :project_id => proj.id, :manufacturer_id => m.id, :eng_id => u.id)
      get 'show', :project_id => proj.id, :id => pur.id
      response.should be_success
    end
  end
  
  describe "seach result" do
    it "should do search for coo" do
      session[:coo] = true
      eng = FactoryGirl.create(:user)
      cust = FactoryGirl.create(:customer)
      proj = FactoryGirl.create(:project, :customer_id => cust.id)
      pur = FactoryGirl.create(:purchasing, :project_id => proj.id, :eng_id => eng.id, :pur_eng_id => nil)
      p_search = FactoryGirl.attributes_for(:purchasing)
      get 'search_results', :purchasing => p_search 
      response.should be_success
      assigns(:purchasings).should eq([pur])
    end
  end
    
end
