require 'spec_helper'

describe Customer do
  describe "data integrity" do
    it "should return error with no name" do
      customer = FactoryGirl.build(:customer, :name => nil)
      customer.should_not be_valid
    end

    it "should take a good name" do
      customer = FactoryGirl.create(:customer, :name => "good customer name")
      customer.errors[:name].should be_empty
    end
    
    it "should reject duplicate customer" do
      customer = FactoryGirl.create(:customer)
      customer1 = FactoryGirl.build(:customer)
      customer1.should_not be_valid
    end

    it "should take good email addresses" do
      emails = %w[user@foo.com user_AT@bar.org Example.User@foo.cn User@goo.info]
      emails.each do |email|
        customer = FactoryGirl.build(:customer, :email => email)
        customer.should be_valid
      end        
    end
    
    it "should reject empty email" do
      customer = FactoryGirl.build(:customer, :email => nil)
      customer.should_not be_valid
    end
        
    it "should reject invalid emails" do
      emails = %w[user@foo,com user_at_foo.org example.user@foo user@foo.]
      emails.each do |email|
        customer = FactoryGirl.build(:customer, :email => email)
        customer.should_not be_valid
      end
    end
    
    it "should reject duplicate emails" do
      customer = FactoryGirl.create(:customer, :email => "t@example.com")
      customer1 = FactoryGirl.build(:customer, :email => "T@Example.COM")
      customer1.should_not be_valid
    end
    
    it "should return error with no short_name" do
      customer = FactoryGirl.build(:customer, :short_name => nil)
      customer.should_not be_valid
    end
    
    it "should return error with duplicate short_name" do
      customer = FactoryGirl.create(:customer, :short_name => "test user")
      customer1 = FactoryGirl.build(:customer, :short_name => "Test User")
      customer1.should_not be_valid      
    end

    it "should not be OK with duplicate short_name in different active status" do
      customer = FactoryGirl.create(:customer, :active => false, :short_name => "test user")
      customer1 = FactoryGirl.build(:customer, :active => true, :short_name => "Test user")
      customer1.should_not be_valid           
    end
    
    it "should return error with no contact" do
      customer = FactoryGirl.build(:customer, :contact_info => nil)
      customer.should_not be_valid
    end

    it "should reject if no customer main biz" do
      customer = FactoryGirl.build(:customer, :main_biz => nil)
      customer.should_not be_valid
    end

    it "should return error with no active" do
      customer = FactoryGirl.build(:customer, :active => nil)
      customer.should_not be_valid
    end  
    
    it "should return error with no phone" do
      customer = FactoryGirl.build(:customer, :phone => nil)
      customer.should_not be_valid
    end  
    
    it "should return error with no address" do
      customer = FactoryGirl.build(:customer, :address => nil)
      customer.should_not be_valid
    end  
             
  end
end
