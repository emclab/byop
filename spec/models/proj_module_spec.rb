require 'spec_helper'

describe ProjModule do
  it "should have a production id" do
    sub = Factory.build(:proj_module, :project_id => nil)
    sub.should_not be_valid
  end
  
  it "should have a name" do
    sub = Factory.build(:proj_module, :name => nil)
    sub.should_not be_valid
  end
  
  it "should reject duplicate name" do
    sub = Factory(:proj_module, :name => 'test')
    sub1 = Factory.build(:proj_module, :name => 'Test')
    sub1.should_not be_valid
  end
end
