# encoding: utf-8
require 'spec_helper'

describe Sourcing do
  
  it "should be OK" do
    s = FactoryGirl.build(:sourcing)
    s.should be_valid  
  end
  
  it "should reject nil prod name" do
    s = Factory.build(:sourcing, :prod_name => nil)
    s.should_not be_valid
  end
  
  it "should reject duplidate prod name" do
    s = Factory(:sourcing, :prod_name => 'name')
    s1 = Factory.build(:sourcing, :prod_name => 'Name')
    s1.should_not be_valid
  end
  
  it "should reject nil project id" do
    s = Factory.build(:sourcing, :project_id => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil spec" do
    s = Factory.build(:sourcing, :spec => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil qty" do
    s = Factory.build(:sourcing, :qty => nil)
    s.should_not be_valid
  end 
  
  it "should reject nil unit" do
    s = Factory.build(:sourcing, :unit => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil start date" do
    s = Factory.build(:sourcing, :start_date => nil)
    s.should_not be_valid
  end   
  
  it "should reject nil finish date" do
    s = Factory.build(:sourcing, :finish_date => nil)
    s.should_not be_valid
  end   
                    
end
