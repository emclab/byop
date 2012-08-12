require 'spec_helper'

describe ProjModule do
  it "should have a production id" do
    sub = FactoryGirl.build(:proj_module, :project_id => nil)
    sub.should_not be_valid
  end
  
  it "should have a name" do
    sub = FactoryGirl.build(:proj_module, :name => nil)
    sub.should_not be_valid
  end
  
  it "should reject duplicate name" do
    sub = FactoryGirl.create(:proj_module, :name => 'test')
    sub1 = FactoryGirl.build(:proj_module, :name => 'Test')
    sub1.should_not be_valid
  end
end
