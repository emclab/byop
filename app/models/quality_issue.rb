# encoding: utf-8
class QualityIssue < ActiveRecord::Base
  attr_accessible :name, :project_id, :production_id, :installation_id, :sourcing_id, :purchasing_id, :report_date, 
                  :report_by_id, :issue_desp, :root_cause, :customer_feedback, :preventative_action, :quick_fix,
                  :solution, :close_date, 
                  :as => :role_new
  attr_accessible :name, :production_id, :installation_id, :sourcing_id, :purchasing_id, :report_date, 
                  :report_by_id, :issue_desp, :root_cause, :customer_feedback, :preventative_action, :quick_fix,
                  :solution, :close_date,
                  :as => :role_update
                   
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :report_by, :class_name => 'User'
  belongs_to :project
  
  validates :name, :presence => true
  validates :issue_desp, :presence => true
  validates_numericality_of :project_id, :greater_than => 0
  validates_numericality_of :report_by_id, :greater_than => 0
  validates :report_date, :presence => true
end
