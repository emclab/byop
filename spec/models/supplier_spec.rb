# encoding: utf-8
require 'spec_helper'

describe Supplier do
  it "should reject nil name" do
    p = Factory.build(:supplier, :name => nil)
    p.should_not be_valid
  end

  it "should reject nil short name" do
    p = Factory.build(:supplier, :short_name => nil)
    p.should_not be_valid
  end  
  
  it "should reject nil phone" do
    p = Factory.build(:supplier, :phone => nil)
    p.should_not be_valid
  end  

  it "should reject nil primary cell" do
    p = Factory.build(:supplier, :cell => nil)
    p.should_not be_valid
  end  

  it "should reject nil primary contact" do
    p = Factory.build(:supplier, :contact => nil)
    p.should_not be_valid
  end 

  it "should reject nil fax" do
    p = Factory.build(:supplier, :fax => nil)
    p.should_not be_valid
  end 

  it "should reject nil quality system" do
    p = Factory.build(:supplier, :quality_system => nil)
    p.should_not be_valid
  end 
  
  it "should reject nil equip" do
    p = Factory.build(:supplier, :main_product => nil)
    p.should_not be_valid
  end   
            
end
