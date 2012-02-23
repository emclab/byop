require 'spec_helper'

describe ProductionLog do
  it "should have a production id" do
    log = Factory.build(:production_log, :production_id => nil)
    log.should_not be_valid
  end
  
  it "should have a log" do
    log = Factory.build(:production_log, :log => nil)
    log.should_not be_valid
  end
end
