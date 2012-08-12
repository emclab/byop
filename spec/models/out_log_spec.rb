require 'spec_helper'

describe OutLog do
  it "should be OK with a normal data" do
    s = FactoryGirl.build(:out_log)
    s.should be_valid
  end
  
  it "should reject nil qty" do
    s = FactoryGirl.build(:out_log, :out_qty => nil)
    s.should_not be_valid
  end
  
  it "should reject 0 qty" do
    s = FactoryGirl.build(:out_log, :out_qty => 0)
    s.should_not be_valid
  end

  it "should reject nil receiver" do
    s = FactoryGirl.build(:out_log, :receiver_id => nil)
    s.should_not be_valid
  end

  it "should reject nil out_date" do
    s = FactoryGirl.build(:out_log, :out_date => nil)
    s.should_not be_valid
  end
        
end
