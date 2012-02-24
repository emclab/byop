# encoding: utf-8
require 'spec_helper'

describe Project do
  it "should reject nil proj name" do
    p = Factory.build(:project, :name => nil)
    p.should_not be_valid
  end
  
  it "should reject if no customer" do
    p = Factory.build(:project, :customer_id => nil)
    p.should_not be_valid
  end
  
  it "should reject if no customer contact info" do
    p = Factory.build(:project, :customer_contact_info => nil)
    p.should_not be_valid
  end
  
  it "should reject if not status" do
    p = Factory.build(:project, :status => nil)
    p.should_not be_valid
  end
end
