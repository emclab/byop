# encoding: utf-8
class ProductionLog < ActiveRecord::Base
  belongs_to :production
  belongs_to :input_by, :class_name => 'User'
   
  attr_accessible :production_id, :log, :as => :role_new
  
  validates_numericality_of :production_id, :greater_than => 0
  validates :log, :presence => true
end
