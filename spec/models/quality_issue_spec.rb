# encoding: utf-8
require 'spec_helper'

describe QualityIssue do
  it "should reject nil name" do
    s = FactoryGirl.build(:quality_issue, :name => nil)
    s.should_not be_valid
  end
  
  it "should reject nil issue desp" do
    s = FactoryGirl.build(:quality_issue, :issue_desp => nil)
    s.should_not be_valid
  end
  
  it "should reject nil project id" do
    s = FactoryGirl.build(:quality_issue, :project_id => nil)
    s.should_not be_valid
  end  
  
  it "should reject nil report id" do
    s = FactoryGirl.build(:quality_issue, :report_by_id => nil)
    s.should_not be_valid
  end  
 
  it "should reject nil report date" do
    s = FactoryGirl.build(:quality_issue, :report_date => nil)
    s.should_not be_valid
  end   
  
end
