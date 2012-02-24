require 'spec_helper'

describe CommLog do
  it "should have a subject" do
    log = Factory.build(:comm_log, :subject => nil)
    log.should_not be_valid
  end
  
  it "should have a log" do
    log = Factory.build(:comm_log, :log => nil)
    log.should_not be_valid
  end
  
  it "should have a purpose" do
    log = Factory.build(:comm_log, :purpose => nil)
    log.should_not be_valid
  end  
  
  it "should have a meanings" do
    log = Factory.build(:comm_log, :via => nil)
    log.should_not be_valid
  end 
  
  it "should have a contact info" do
    log = Factory.build(:comm_log, :contact_with => nil)
    log.should_not be_valid
  end  
end
