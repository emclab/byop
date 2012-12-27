require 'spec_helper'

describe PayStatusLog do
  it "should reject nil payment log id" do
    log = FactoryGirl.build(:pay_status_log, :payment_log_id => nil)
    log.should_not be_valid
  end
    
  it "should have a log" do
    log = FactoryGirl.build(:pay_status_log, :log => nil)
    log.should_not be_valid
  end
end
