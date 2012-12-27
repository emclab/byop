class PayStatusLog < ActiveRecord::Base
  belongs_to :payment_log
  belongs_to :input_by, :class_name => 'User'
  
  attr_accessible :log, :payment_log_id, :as => :role_new
  validates_numericality_of :payment_log_id, :greater_than => 0
  validates :log, :presence => true
end
