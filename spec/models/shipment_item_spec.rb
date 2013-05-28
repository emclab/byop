# encoding: utf-8
require 'spec_helper'

describe ShipmentItem do
  it "should be valid" do
    s = FactoryGirl.build(:shipment_item)
    s.should be_valid  
  end
  
  it "should reject nil name" do
    s = FactoryGirl.build(:shipment_item, :name => nil)
    s.should_not be_valid
  end
    
  it "should reject nil qty" do
    s = FactoryGirl.build(:shipment_item, :qty => nil)
    s.should_not be_valid
  end
  
  it "should reject 0 qty" do
    s = FactoryGirl.build(:shipment_item, :qty => 0)
    s.should_not be_valid
  end
  
  it "should reject nil unit" do
    s = FactoryGirl.build(:shipment_item, :unit => nil)
    s.should_not be_valid
  end
  
  it "should reject nil spec" do
    s = FactoryGirl.build(:shipment_item, :spec => nil)
    s.should_not be_valid    
  end 
end
