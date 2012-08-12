require 'spec_helper'

describe InstallationLog do
  it "should have a production id" do
    log = FactoryGirl.build(:installation_log, :installation_id => nil)
    log.should_not be_valid
  end
  
  it "should have a log" do
    log = FactoryGirl.build(:installation_log, :log => nil)
    log.should_not be_valid
  end
end
