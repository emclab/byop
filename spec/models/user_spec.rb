require 'spec_helper'

describe User do
  it "should reject nil login" do
    u = Factory.build(:user, :login => nil)
    u.should_not be_valid
  end
  
  it "should reject nil status" do
    u = Factory.build(:user, :status => nil)
    u.should_not be_valid
  end
  
  it "should reject nil name" do
    u = Factory.build(:user, :name => nil)
    u.should_not be_valid
  end
  
  it "should reject nil user_type" do
    u = Factory.build(:user, :user_type => nil)
    u.should_not be_valid
  end
  
  it "should reject nil password" do
    u = Factory.build(:user, :password => nil)
    u.should_not be_valid
  end
  
  it "should reject -0- input_by_id" do
    u = Factory.build(:user, :input_by_id => 0)
    u.should_not be_valid
  end
end
