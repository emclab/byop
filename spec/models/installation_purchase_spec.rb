# encoding: utf-8
require 'spec_helper'

describe InstallationPurchase do
  it "should be OK for normal reccord" do
    s = Factory.build(:installation_purchase)
    s.should be_valid  
  end
  
  it "should reject non integer qty purchased" do
    s = Factory.build(:installation_purchase, :qty_purchased => 2.4, :purchased => true)
    s.should_not be_valid
  end
  
  it "should reject nil part name" do
    s = Factory.build(:installation_purchase, :part_name => nil)
    s.should_not be_valid
  end
  
  it "should reject nil installation id" do
    s = Factory.build(:installation_purchase, :installation_id => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil for what" do
    s = Factory.build(:installation_purchase, :for_what => nil)
    s.should_not be_valid
  end
  
  it "should reject nil spec" do
    s = Factory.build(:installation_purchase, :spec => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil qty" do
    s = Factory.build(:installation_purchase, :qty => nil)
    s.should_not be_valid
  end 
  
  it "should reject nil applicant id" do
    s = Factory.build(:installation_purchase, :applicant_id => 0)
    s.should_not be_valid
  end
  
  it "should reject nil unit" do
    s = Factory.build(:installation_purchase, :unit => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil need date" do
    s = Factory.build(:installation_purchase, :need_date => nil)
    s.should_not be_valid
  end   
  
  it "should reject if purchased true and total_paid as nil" do
    s = Factory.build(:installation_purchase, :purchased => true, :total_paid => nil)
    s.should_not be_valid
  end

  it "should reject if purchased true and qty in stock as nil" do
    s = Factory.build(:installation_purchase, :purchased => true, :qty_in_stock => nil)
    s.should_not be_valid
  end
    
end
