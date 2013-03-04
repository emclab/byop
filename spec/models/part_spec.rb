# encoding: utf-8
require 'spec_helper'
require 'pp'

describe Part do
  
  it "should be valid" do
    s = FactoryGirl.build(:part)
    s.should be_valid  
  end
  
  it "should reject nil name" do
    s = FactoryGirl.build(:part, :name => nil)
    s.should_not be_valid
  end
    
  it "should reject nil in_qty" do
    s = FactoryGirl.build(:part, :in_qty => nil)
    s.should_not be_valid
  end

  it "should reject 0 in_qty" do
    s = FactoryGirl.build(:part, :in_qty => 0)
    s.should_not be_valid
  end
    
  it "should reject nil stock_qty" do
    s = FactoryGirl.build(:part, :stock_qty => nil)
    s.should_not be_valid
  end
  
  it "should be OK with 0 stock_qty" do
    s = FactoryGirl.build(:part, :in_qty => 1, :stock_qty => 0)
    s.should be_valid
  end    
  
  it "should reject stock_qty > in_qty" do
    s = FactoryGirl.build(:part, :stock_qty => 2, :in_qty => 1)
    s.should_not be_valid
  end  

  it "should be OK if stock_qty == in_qty" do
    s = FactoryGirl.build(:part, :stock_qty => 2, :in_qty => 2)
    s.should be_valid
  end  
    
  it "should reject nil unit" do
    s = FactoryGirl.build(:part, :unit => nil)
    s.should_not be_valid
  end
  
  it "should reject nil spec" do
    s = FactoryGirl.build(:part, :spec => nil)
    s.should_not be_valid    
  end 
  
  it "should reject nil unit_price" do
    s = FactoryGirl.build(:part, :unit_price => nil)
    s.should_not be_valid 
  end 
end
