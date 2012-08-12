# encoding: utf-8
require 'spec_helper'

describe Production do
  it "should reject nil name" do
    s = FactoryGirl.build(:production, :name => nil)
    s.should_not be_valid
  end
  
  it "should reject duplidate name" do
    s = FactoryGirl.create(:production, :name => 'name')
    s1 = FactoryGirl.build(:production, :name => 'Name')
    s1.should_not be_valid
  end
  
  it "should reject nil project id" do
    s = FactoryGirl.build(:production, :project_id => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil  eng id" do
    s = FactoryGirl.build(:production, :eng_id => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil start date" do
    s = FactoryGirl.build(:production, :start_date => nil)
    s.should_not be_valid
  end   
  
  it "should reject nil finish date" do
    s = FactoryGirl.build(:production, :finish_date => nil)
    s.should_not be_valid
  end   
end
