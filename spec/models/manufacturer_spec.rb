require 'spec_helper'

describe Manufacturer do
 it "name shouldn't be nil" do
    mfg = Factory.build(:manufacturer, :name => nil)
    mfg.should_not be_valid
  end
  
  it "should reject duplidate name" do
    mfg1 = Factory(:manufacturer, :name => 'test')
    mfg2 = Factory.build(:manufacturer, :name => 'TEst')
    
    mfg2.should_not be_valid
  end
    
end
