require 'spec_helper'

describe PurchasingLog do
  it "should have a production id" do
    log = Factory.build(:purchasing_log, :purchasing_id => nil)
    log.should_not be_valid
  end
  
  it "should have a log" do
    log = Factory.build(:purchasing_log, :log => nil)
    log.should_not be_valid
  end
end
