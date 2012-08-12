# encoding: utf-8
require 'spec_helper'

describe Supplier do
  it "should reject nil name" do
    p = FactoryGirl.build(:supplier, :name => nil)
    p.should_not be_valid
  end

  it "should reject nil short name" do
    p = FactoryGirl.build(:supplier, :short_name => nil)
    p.should_not be_valid
  end  
  
  it "should reject nil phone" do
    p = FactoryGirl.build(:supplier, :phone => nil)
    p.should_not be_valid
  end  

  it "should reject nil primary cell" do
    p = FactoryGirl.build(:supplier, :cell => nil)
    p.should_not be_valid
  end  

  it "should reject nil primary contact" do
    p = FactoryGirl.build(:supplier, :contact => nil)
    p.should_not be_valid
  end 

  it "should reject nil fax" do
    p = FactoryGirl.build(:supplier, :fax => nil)
    p.should_not be_valid
  end 

  it "should reject nil quality system" do
    p = FactoryGirl.build(:supplier, :quality_system => nil)
    p.should_not be_valid
  end 
  
  it "should reject nil equip" do
    p = FactoryGirl.build(:supplier, :main_product => nil)
    p.should_not be_valid
  end   
            
end
