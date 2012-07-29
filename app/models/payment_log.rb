# encoding: utf-8
class PaymentLog < ActiveRecord::Base
  
  belongs_to :purchasing
  belongs_to :sourcing
  belongs_to :input_by, :class_name => 'User'
  
  attr_accessible :pay_date, :amount, :short_note, :as => :role_new_update
  
  validates :pay_date, :presence => true
end
