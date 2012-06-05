# encoding: utf-8
class SysLog < ActiveRecord::Base
  attr_accessible :log_date, :user_name, :user_id, :user_ip, :action_logged, :as => :new_log
  
  validates :log_date, :presence => true
  
  def self.trim_log(num_record)
    SysLog.limit(num_record).destroy_all
  end
end
