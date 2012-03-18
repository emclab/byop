# encoding: utf-8
class Project < ActiveRecord::Base
  attr_accessible :name, :customer_id, :status, :install_address, :budget, :tech_spec, :subsys_spec, :other_tech_requirement, :test_run_requirement,
                  :construction_requirement, :turn_over_requirement, :bid_doc_available_date, :bid_deadline, :bid_opening_date, :contract_date,
                  :production_start_date, :construction_finish_date, :install_start_date, :test_run_date, :turn_over_date, :note, :customer_contact_info,
                  :as => :role_new
  attr_accessible :name,       :status, :install_address, :budget, :tech_spec, :subsys_spec, :other_tech_requirement, :test_run_requirement,
                  :construction_requirement, :turn_over_requirement, :bid_doc_available_date, :bid_deadline, :bid_opening_date, :contract_date,
                  :production_start_date, :construction_finish_date, :install_start_date, :test_run_date, :turn_over_date, :note, :customer_contact_info,
                  :review_after, :completed, :cancelled, :awarded,
                  :as => :role_update    
                                
  belongs_to :input_by, :class_name => 'User'
  belongs_to :customer
  has_many :project_logs
  has_many :productions
  has_many :sourcings
  has_many :purchasings
  has_many :installations
  has_many :proj_modules
  has_many :quality_issues
  
  validates :name, :presence => true, :uniqueness => true
  validates_numericality_of :customer_id, :greater_than => 0
  validates :status, :presence => true
  validates :tech_spec, :presence => true
  validates :customer_contact_info, :presence => true
   
  scope :not_cancelled_project, where(:cancelled => false)
  scope :cancelled_project, where(:cancelled => true) 
  scope :completed_project, where(:completed => true) 
  scope :ongoing_project, where(:completed => false)                  
end

 