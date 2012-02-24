# encoding: utf-8
require 'spec_helper'

describe Installation do
  it "should reject nil name" do
    s = Factory.build(:installation, :install_name => nil)
    s.should_not be_valid
  end
  
  it "should reject duplidate name" do
    s = Factory(:installation, :install_name => 'naMe')
    s1 = Factory.build(:installation, :install_name => 'name')
    s1.should_not be_valid
  end
  
  it "should reject nil project id" do
    s = Factory.build(:installation, :project_id => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil inst eng id" do
    s = Factory.build(:installation, :inst_eng_id => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil start date" do
    s = Factory.build(:installation, :start_date => nil)
    s.should_not be_valid
  end   
  
  it "should reject nil finish date" do
    s = Factory.build(:installation, :finish_date => nil)
    s.should_not be_valid
  end   
end
