require 'spec_helper'

describe User do
  it "should be OK" do
    ul = FactoryGirl.build(:user_level)
    u = FactoryGirl.build(:user, :user_levels => [ul])
    u.should be_valid
  end
  
  it "should rejct duplicate login" do
    u0 = FactoryGirl.create(:user, :login => 'loginname')
    u = FactoryGirl.build(:user, :login => 'Loginname')
    u.should_not be_valid
  end
  
  it "should rejct duplicate login" do
    u0 = FactoryGirl.create(:user, :name => 'loginname')
    u = FactoryGirl.build(:user, :name => 'Loginname')
    u.should_not be_valid
  end
  
  it "should reject nil login" do
    u = FactoryGirl.build(:user, :login => nil)
    u.should_not be_valid
  end
  
  it "should reject nil status" do
    u = FactoryGirl.build(:user, :status => nil)
    u.should_not be_valid
  end
  
  it "should reject nil name" do
    u = FactoryGirl.build(:user, :name => nil)
    u.should_not be_valid
  end
  
  it "should reject nil user_type" do
    u = FactoryGirl.build(:user, :user_type => nil)
    u.should_not be_valid
  end
  
  it "should reject nil password" do
    u = FactoryGirl.build(:user, :password => nil)
    u.should_not be_valid
  end
  
  it "should reject -0- input_by_id" do
    u = FactoryGirl.build(:user, :input_by_id => 0)
    u.should_not be_valid
  end
end
