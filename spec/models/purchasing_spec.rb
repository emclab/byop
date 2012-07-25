# encoding: utf-8
require 'spec_helper'

describe Purchasing do
  it "should be OK" do
    s = FactoryGirl.build(:purchasing)
    s.should be_valid
  end
  
  it "should reject nil total" do
    s = FactoryGirl.build(:purchasing, :total => nil)
    s.should_not be_valid
  end
  
  it "should reject nil prod name" do
    s = Factory.build(:purchasing, :prod_name => nil)
    s.should_not be_valid
  end
  
  it "should reject duplidate prod name" do
    s = Factory(:purchasing, :prod_name => 'Name')
    s1 = Factory.build(:purchasing, :prod_name => 'name')
    s1.should_not be_valid
  end
  
  it "should reject nil project id" do
    s = Factory.build(:purchasing, :project_id => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil eng id" do
    s = Factory.build(:purchasing, :eng_id => nil)
    s.should_not be_valid
  end  

  it "should reject nil manufacturer id" do
    s = Factory.build(:purchasing, :manufacturer_id => nil)
    s.should_not be_valid
  end  
    
  it "should reject nil spec" do
    s = Factory.build(:purchasing, :spec => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil qty" do
    s = Factory.build(:purchasing, :qty => nil)
    s.should_not be_valid
  end 
  
  it "should reject nil unit" do
    s = Factory.build(:purchasing, :unit => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil order date" do
    s = Factory.build(:purchasing, :order_date => nil)
    s.should_not be_valid
  end   
  
  it "should reject nil delivery date" do
    s = Factory.build(:purchasing, :delivery_date => nil)
    s.should_not be_valid
  end   
end
