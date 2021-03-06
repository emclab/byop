# encoding: utf-8
require 'spec_helper'

describe Purchasing do
  it "should be OK" do
    s = FactoryGirl.build(:purchasing)
    s.should be_valid
  end
  
  it "should reject nil prod name" do
    s = FactoryGirl.build(:purchasing, :prod_name => nil)
    s.should_not be_valid
  end
  
  it "should reject duplidate prod name" do
    s = FactoryGirl.create(:purchasing, :prod_name => 'name', :project_id => 1)
    s1 = FactoryGirl.build(:purchasing, :prod_name => 'name', :project_id => 1)
    s1.should_not be_valid
  end
  
  it "should allow duplicate prod name for different project" do
    s = FactoryGirl.create(:purchasing, :prod_name => 'name', :project_id => 2)
    s1 = FactoryGirl.build(:purchasing, :prod_name => 'name', :project_id => 1)
    s1.should be_valid    
  end
  
  it "should reject nil project id" do
    s = FactoryGirl.build(:purchasing, :project_id => nil)
    s.should_not be_valid
  end  
  
  it "should be OK with nil approve_eng_id" do
    s = FactoryGirl.build(:purchasing, :approve_eng_id => nil)
    s.should be_valid
  end 
  
  it "should reject 0 approve_eng_id" do
    s = FactoryGirl.build(:purchasing, :approve_eng_id => 0)
    s.should_not be_valid
  end 
  
  it "should be OK with nil approve_pur_eng_id" do
    s = FactoryGirl.build(:purchasing, :approve_pur_eng_id => nil)
    s.should be_valid
  end 
  
  it "should reject 0 approve_pur_eng_id" do
    s = FactoryGirl.build(:purchasing, :approve_pur_eng_id => 0)
    s.should_not be_valid
  end 
  
  it "should be OK with nil approve_vp_eng_id" do
    s = FactoryGirl.build(:purchasing, :approve_vp_eng_id => nil)
    s.should be_valid
  end 
  
  it "should reject 0 approve_vp_eng_id" do
    s = FactoryGirl.build(:purchasing, :approve_vp_eng_id => 0)
    s.should_not be_valid
  end 
  
  it "should be OK with nil approve_ceo_id" do
    s = FactoryGirl.build(:purchasing, :approve_ceo_id => nil)
    s.should be_valid
  end 
  
  it "should reject 0 approve_ceo_id" do
    s = FactoryGirl.build(:purchasing, :approve_ceo_id => 0)
    s.should_not be_valid
  end 

  #it "should reject nil manufacturer id" do
  #  s = FactoryGirl.build(:purchasing, :manufacturer_id => nil)
   # s.should_not be_valid
  #end  
    
  it "should reject nil spec" do
    s = FactoryGirl.build(:purchasing, :spec => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil qty" do
    s = FactoryGirl.build(:purchasing, :qty => nil)
    s.should_not be_valid
  end 
  
  it "should reject nil unit" do
    s = FactoryGirl.build(:purchasing, :unit => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil order date" do
    s = FactoryGirl.build(:purchasing, :order_date => nil)
    s.should_not be_valid
  end   
  
  #it "should reject nil delivery date" do
 #   s = FactoryGirl.build(:purchasing, :delivery_date => nil)
 #   s.should_not be_valid
  #end   
end
