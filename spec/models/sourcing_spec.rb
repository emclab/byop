# encoding: utf-8
require 'spec_helper'

describe Sourcing do
  
  it "should be OK" do
    s = FactoryGirl.build(:sourcing)
    s.should be_valid  
  end
  
  it "should reject nil prod name" do
    s = FactoryGirl.build(:sourcing, :prod_name => nil)
    s.should_not be_valid
  end
  
  it "should reject duplidate prod name" do
    s = FactoryGirl.create(:sourcing, :prod_name => 'name', :project_id => 1)
    s1 = FactoryGirl.build(:sourcing, :prod_name => 'name', :project_id => 1)
    s1.should_not be_valid
  end

  it "should allow duplidate prod name for different project" do
    s = FactoryGirl.create(:sourcing, :prod_name => 'name', :project_id => 2)
    s1 = FactoryGirl.build(:sourcing, :prod_name => 'name', :project_id => 1)
    s1.should be_valid
  end
    
  it "should reject nil project id" do
    s = FactoryGirl.build(:sourcing, :project_id => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil spec" do
    s = FactoryGirl.build(:sourcing, :spec => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil qty" do
    s = FactoryGirl.build(:sourcing, :qty => nil)
    s.should_not be_valid
  end 
  
  it "should reject nil unit" do
    s = FactoryGirl.build(:sourcing, :unit => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil start date" do
    s = FactoryGirl.build(:sourcing, :start_date => nil)
    s.should_not be_valid
  end   
  
  it "should reject nil finish date" do
    s = FactoryGirl.build(:sourcing, :finish_date => nil)
    s.should_not be_valid
  end   
                    
end
