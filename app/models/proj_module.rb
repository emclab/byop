# encoding: utf-8
class ProjModule < ActiveRecord::Base
  belongs_to :project
  belongs_to :input_by, :class_name => 'User'
   
  attr_accessible :project_id, :name, :as => :role_new
  
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates_numericality_of :project_id, :greater_than => 0
end
