# encoding: utf-8
require 'spec_helper'

describe ProjectLog do

  it "should reject nil project id" do
    log = FactoryGirl.build(:project_log, :project_id => nil)
    log.should_not be_valid
  end
    
  it "should have a subject" do
    log = FactoryGirl.build(:project_log, :subject => nil)
    log.should_not be_valid
  end
  
  it "should have a log" do
    log = FactoryGirl.build(:project_log, :log => nil)
    log.should_not be_valid
  end
  
end
