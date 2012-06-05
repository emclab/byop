# encoding: utf-8
require 'spec_helper'

describe SysLog do
  it "should destroy all using scope" do
    10.times { FactoryGirl.create(:sys_log) }
    lambda do
      SysLog.trim_log(5)
    end.should change(SysLog, :count).by(-5)
  end
  
  it "should log right" do
    log = FactoryGirl.build(:sys_log)
    log.should be_valid
  end
  
  it "should reject nil log date" do
    log = FactoryGirl.build(:sys_log, :log_date => nil)
    log.should_not be_valid
  end

  it "should add one record in sys_logs table" do
    log = SysLog.new({:log_date => Time.now}, :as => :new_log)
    lambda do
      log.save
    end.should change(SysLog, :count).by(1)
  end    
end
