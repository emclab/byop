# encoding: utf-8
class UserLevel < ActiveRecord::Base
  belongs_to :user
  
  #validates :role, :presence => true
  validates :position, :presence => true
  #validates_numericality_of :user_id, :greater_than => 0
end
