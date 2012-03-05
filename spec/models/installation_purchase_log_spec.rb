require 'spec_helper'

describe InstallationPurchaseLog do
   it "should have a installation purchase id" do
    log = Factory.build(:installation_purchase_log, :installation_purchase_id => nil)
    log.should_not be_valid
  end
  
  it "should have a log" do
    log = Factory.build(:installation_purchase_log, :log => nil)
    log.should_not be_valid
  end
end
