require 'spec_helper'

describe Manufacturer do
 it "name shouldn't be nil" do
    mfg = FactoryGirl.build(:manufacturer, :name => nil)
    mfg.should_not be_valid
  end
  
  it "should reject duplidate name" do
    mfg1 = FactoryGirl.create(:manufacturer, :name => 'test')
    mfg2 = FactoryGirl.build(:manufacturer, :name => 'TEst')
    
    mfg2.should_not be_valid
  end
    
end
