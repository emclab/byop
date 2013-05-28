# encoding: utf-8
require 'spec_helper'

describe Shipment do
  it "should be valid" do
    s = FactoryGirl.build(:shipment)
    s.should be_valid  
  end
  
  it "should reject nil shipping date" do
    s = FactoryGirl.build(:shipment, :shipping_date => nil)
    s.should_not be_valid  
  end
  
  it "should reject nil delivery address" do
    s = FactoryGirl.build(:shipment, :delivery_address => nil)
    s.should_not be_valid 
  end
  
  it "should reject nil freight description" do
    s = FactoryGirl.build(:shipment, :freight_desp => nil)
    s.should_not be_valid 
  end
  
  it "should reject nil project_id" do
    s = FactoryGirl.build(:shipment, :project_id => nil)
    s.should_not be_valid 
  end
end
