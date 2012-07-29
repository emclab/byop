require 'spec_helper'

describe PaymentLog do
  it "should be OK" do
    p = FactoryGirl.build(:payment_log)
    p.should be_valid
  end
  
  it "should reject nit pay date" do
    p = FactoryGirl.build(:payment_log, :pay_date => nil)
    p.should_not be_valid
  end
end
