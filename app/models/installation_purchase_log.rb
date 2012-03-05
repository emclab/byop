# encoding: utf-8
class InstallationPurchaseLog < ActiveRecord::Base
  belongs_to :installation
  belongs_to :input_by, :class_name => 'User'
   
  attr_accessible :installation_purchase_id, :log, :as => :role_new
  
  validates_numericality_of :installation_purchase_id, :greater_than => 0
  validates :log, :presence => true
end
