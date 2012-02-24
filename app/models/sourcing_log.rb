# encoding: utf-8
class SourcingLog < ActiveRecord::Base
  belongs_to :sourcing
  belongs_to :input_by, :class_name => 'User'
   
  attr_accessible :sourcing_id, :log, :as => :role_new
  
  validates_numericality_of :sourcing_id, :greater_than => 0
  validates :log, :presence => true
end
