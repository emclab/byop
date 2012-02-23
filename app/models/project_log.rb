# encoding: utf-8
class ProjectLog < ActiveRecord::Base
  belongs_to :project
  belongs_to :input_by, :class_name => 'User'
   
  attr_accessible :subject, :project_id, :log, :as => :role_new
  
  validates :subject, :presence => true
  validates :log, :presence => true
  validates_numericality_of :project_id, :greater_than => 0
end
