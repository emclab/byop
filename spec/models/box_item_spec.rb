# encoding: utf-8
require 'spec_helper'

describe BoxItem do
  it "should be valid" do
    s = FactoryGirl.build(:box_item)
    s.should be_valid  
  end
  
  it "should reject nil name" do
    s = FactoryGirl.build(:box_item, :name => nil)
    s.should_not be_valid
  end
  
  it "should reject duplicate name" do
    s0 = FactoryGirl.create(:box_item, :name => 'NIl')
    s = FactoryGirl.build(:box_item, :name => 'nil')
    s.should_not be_valid
  end
    
  it "should reject nil qty" do
    s = FactoryGirl.build(:box_item, :qty => nil)
    s.should_not be_valid
  end
  
  it "should reject 0 qty" do
    s = FactoryGirl.build(:box_item, :qty => 0)
    s.should_not be_valid
  end
  
  it "should reject nil unit" do
    s = FactoryGirl.build(:box_item, :unit => nil)
    s.should_not be_valid
  end
  
  it "should reject nil spec" do
    s = FactoryGirl.build(:box_item, :spec => nil)
    s.should_not be_valid    
  end 
end
