# encoding: utf-8
class PurchasingLog < ActiveRecord::Base
  belongs_to :purchasing
  belongs_to :input_by, :class_name => 'User'
   
  attr_accessible :purchasing_id, :log, :as => :role_new
  
  validates_numericality_of :purchasing_id, :greater_than => 0
  validates :log, :presence => true
end
