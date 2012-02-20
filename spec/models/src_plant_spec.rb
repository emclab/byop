# encoding: utf-8
require 'spec_helper'

describe SrcPlant do
  it "should reject nil name" do
    p = Factory.build(:src_plant, :name => nil)
    p.should_not be_valid
  end

  it "should reject nil short name" do
    p = Factory.build(:src_plant, :short_name => nil)
    p.should_not be_valid
  end  
  
  it "should reject nil phone" do
    p = Factory.build(:src_plant, :phone => nil)
    p.should_not be_valid
  end  

  it "should reject nil primary cell" do
    p = Factory.build(:src_plant, :primary_cell => nil)
    p.should_not be_valid
  end  

  it "should reject nil primary contact" do
    p = Factory.build(:src_plant, :primary_contact => nil)
    p.should_not be_valid
  end 

  it "should reject nil fax" do
    p = Factory.build(:src_plant, :fax => nil)
    p.should_not be_valid
  end 

  it "should reject nil quality system" do
    p = Factory.build(:src_plant, :quality_system => nil)
    p.should_not be_valid
  end 
  
  it "should reject nil equip" do
    p = Factory.build(:src_plant, :equip => nil)
    p.should_not be_valid
  end 
  
  it "should reject nil quality system" do
    p = Factory.build(:src_plant, :tech_ability => nil)
    p.should_not be_valid
  end  
  
  it "should reject nil main_product" do
    p = Factory.build(:src_plant, :tech_ability => nil)
    p.should_not be_valid    
  end   
            
end
