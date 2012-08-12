require 'spec_helper'

describe SourcingLog do
  it "should have a production id" do
    log = FactoryGirl.build(:sourcing_log, :sourcing_id => nil)
    log.should_not be_valid
  end
  
  it "should have a log" do
    log = FactoryGirl.build(:sourcing_log, :log => nil)
    log.should_not be_valid
  end
end
