# encoding: utf-8
require 'spec_helper'

describe Production do
  it "should reject nil name" do
    s = Factory.build(:production, :name => nil)
    s.should_not be_valid
  end
  
  it "should reject duplidate name" do
    s = Factory(:production, :name => 'name')
    s1 = Factory.build(:production, :name => 'Name')
    s1.should_not be_valid
  end
  
  it "should reject nil project id" do
    s = Factory.build(:production, :project_id => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil  eng id" do
    s = Factory.build(:production, :eng_id => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil start date" do
    s = Factory.build(:production, :start_date => nil)
    s.should_not be_valid
  end   
  
  it "should reject nil finish date" do
    s = Factory.build(:production, :finish_date => nil)
    s.should_not be_valid
  end   
end
