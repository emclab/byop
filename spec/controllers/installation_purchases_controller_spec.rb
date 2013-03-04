# encoding: utf-8
require 'spec_helper'

describe InstallationPurchasesController do

  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views
  
  describe "'index'" do
    it "returns http success for hydr eng" do
      session[:hydr_eng] = true
      p = FactoryGirl.create(:project)
      inst = FactoryGirl.create(:installation, :project_id => p.id)
      pur = FactoryGirl.create(:installation_purchase, :installation_id => inst.id)
      get 'index', :installation_id => inst.id
      response.should be_success
    end
    
    it "should OK for mech eng" do
      p = FactoryGirl.create(:project)
      inst = FactoryGirl.create(:installation, :project_id => p.id)
      pur = FactoryGirl.create(:installation_purchase, :installation_id => inst.id)
      session[:mech_eng] = true
      get 'index', :installation_id => inst.id
      response.should be_success      
    end
  end

  describe "'new'" do
    it "reject those without rights" do
      inst = FactoryGirl.create(:installation)
      pur = FactoryGirl.attributes_for(:installation_purchase, :installation_id => inst.id)
      get 'new', :installation_id => inst.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should allow vp eng" do
      inst = FactoryGirl.create(:installation)
      pur = FactoryGirl.attributes_for(:installation_purchase, :installation_id => inst.id)
      session[:vp_eng] = true
      get 'new', :installation_id => inst.id
      response.should be_success
    end
    
    it "should allow inst eng" do
      inst = FactoryGirl.create(:installation)
      pur = FactoryGirl.attributes_for(:installation_purchase, :installation_id => inst.id)
      session[:inst_eng] = true
      get 'new', :installation_id => inst.id
      response.should be_success
    end
        
  end

  describe "'create'" do
    it "reject those without right" do
      inst = FactoryGirl.create(:installation)
      pur = FactoryGirl.attributes_for(:installation_purchase, :installation_id => inst.id)
      get 'create', :installation_id => inst.id, :installation_purchase => pur
      response.should be_success
    end
    
    it "should OK for inst_eng and increase record count by 1 " do
      session[:inst_eng] = true
      u = FactoryGirl.create(:user)
      inst = FactoryGirl.create(:installation)
      pur = FactoryGirl.attributes_for(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id) 
      lambda do
        get 'create', :installation_id => inst.id, :installation_purchase => pur
        response.should redirect_to URI.escape("/view_handler?index=0&msg=申请已保存！")
      end.should change(InstallationPurchase, :count).by(1)
    end
    
    it "should redirec to 'new' for data error and no record count increase" do
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      inst = FactoryGirl.create(:installation)
      pur = FactoryGirl.attributes_for(:installation_purchase, :part_name => nil, :input_by_id => u.id, :installation_id => inst.id) 
      lambda do
        get 'create', :installation_id => inst.id, :installation_purchase => pur
        response.should render_template('new')
      end.should change(InstallationPurchase, :count).by(0)
    end  
      
  end

  describe "'edit'" do
    it "reject those without rights" do
      inst = FactoryGirl.create(:installation)
      pur = FactoryGirl.create(:installation_purchase, :installation_id => inst.id)
      get 'edit', :installation_id => inst.id, :id => pur.id
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
    
    it "should OK for vp eng" do
      inst = FactoryGirl.create(:installation)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id)
      get 'edit', :installation_id => inst.id, :id => pur.id
      response.should be_success
    end
  end

  describe "'update'" do
    it "success for ceo" do
      inst = FactoryGirl.create(:installation)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id)
      get 'update', :installation_id => inst.id, :id => pur.id, :installation_purchase => {:part_name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=申请已更改！")
    end
    
    it "redirect to 'edit' with data error" do
      inst = FactoryGirl.create(:installation)
      session[:ceo] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id)
      get 'update', :installation_id => inst.id, :id => pur.id, :installation_purchase => {:need_date => nil}
      response.should render_template('edit')
    end
    
    it "should not update the approved_by_vp_eng, approved_by_ceo when updating" do
      inst = FactoryGirl.create(:installation)
      session[:vp_eng] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id, :approved_by_vp_eng => nil, :approve_vp_eng_id => nil, 
                               :approved_by_ceo => nil, :approve_ceo_id => nil)
      get 'update', :installation_id => inst.id, :id => pur.id, :installation_purchase => {:part_name => 'new new name'}
      response.should redirect_to URI.escape("/view_handler?index=0&msg=申请已更改！")
      pur.reload.approved_by_ceo.should eq nil 
      pur.reload.approve_ceo_id.should eq nil
      pur.reload.approved_by_vp_eng.should eq nil 
      pur.reload.approve_vp_eng_id.should eq nil     
    end 
    
  end

  describe "'show'" do
    it "should reject those without right" do
      u = FactoryGirl.create(:user)
      inst = FactoryGirl.create(:installation)
      pur = FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id, :applicant_id => u.id)
      get 'show', :installation_id => inst.id, :id => pur.id      
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")  
    end
    
    it "returns http success for those with right" do
      inst = FactoryGirl.create(:installation)
      session[:elec_eng] = true
      u = FactoryGirl.create(:user)
      pur = FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id, :applicant_id => u.id)
      get 'show', :installation_id => inst.id, :id => pur.id
      response.should be_success
    end
  end
  
  describe "approve" do
    it "should nothing happens for those without rights" do
      inst = FactoryGirl.create(:installation)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id
      pur= FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :approved_by_vp_eng => false)
      put 'approve', :installation_id => inst.id, :id => pur.id, :installation_purchase => {:approved_by_vp_eng => true}, :method => :put
      response.should redirect_to URI.escape("/view_handler?index=0&msg=权限不足!")
    end    
  end
  
  describe "warehousing" do
    it "should allow warehousing for pur_eng for right record" do
      session[:pur_eng] = true
      inst = FactoryGirl.create(:installation)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id     
      pur = FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id, :qty_in_stock => 2, 
                    :total_paid => 71.5, :purchased => true, :qty_purchased => 2)
      lambda do                
        put 'warehousing', :id => pur.id, :part => {:storage_location => 'somewhere', :in_date => '2012-3-2'}
        response.should redirect_to installation_installation_purchase_path(inst, pur)
        flash[:notice].should == '物料已入库！'
      end.should change(Part, :count).by(1)
    end
    
    it "should reject for those without right" do
      inst = FactoryGirl.create(:installation)
      u = FactoryGirl.create(:user)
      session[:user_id] = u.id  
      pur = FactoryGirl.create(:installation_purchase, :input_by_id => u.id, :installation_id => inst.id, :qty_in_stock => 2, 
                    :total_paid => 71.5, :purchased => true, :qty_purchased => 2)   
      put 'warehousing', :id => pur.id, :part => {:storage_location => 'somewhere', :in_date => '2012-3-2'}
      response.should be_success   ##no redirect_to
    end
  end

end

