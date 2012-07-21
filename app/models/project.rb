# encoding: utf-8
class Project < ActiveRecord::Base
  
  attr_accessor   :customer_id_search, :start_date_search, :end_date_search, :awarded_search, :cancelled_search, 
                  :completed_search, :time_frame
  
  attr_accessible :customer_id_search, :start_date_search, :end_date_search, :awarded_search, :completed_search, :cancelled_search,
                  :time_frame, :as => :role_search_stats
  
  attr_accessible :name, :customer_id, :status, :install_address, :budget, :tech_spec, 
                  :bid_doc_available_date, :bid_deadline, :bid_opening_date, :contract_date,
                  :production_start_date,  :note, :customer_contact_info, :awarded,
                  :as => :role_new
  attr_accessible :name,       :status, :install_address, :budget, :tech_spec, :subsys_spec, :other_tech_requirement, 
                  :construction_requirement, :turn_over_requirement, :bid_doc_available_date, :bid_deadline, :bid_opening_date, :contract_date,
                  :production_start_date, :construction_finish_date, :install_start_date, :note, :customer_contact_info,
                  :review_after, :completed, :cancelled, :awarded, :design_start_date,
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
  scope :ongoing_project, where(:completed => false, :cancelled => false) 
  
  def find_projects
    projects = Project.where('created_at > ?', 6.years.ago).order('created_at DESC')
    projects = projects.where('awarded = ?', true) if awarded_search.present? && awarded_search == 'true'
    projects = projects.where('awarded = ? OR awarded IS NULL', false) if awarded_search.present? && awarded_search == 'false'
    projects = projects.where('completed = ?', true) if completed_search.present? && completed_search == 'true'
    projects = projects.where('completed = ?', false) if completed_search.present? && completed_search == 'false'
    projects = projects.where('cancelled = ?', false) if cancelled_search.present? && cancelled_search == 'false'
    projects = projects.where('cancelled = ?', true) if cancelled_search.present? && cancelled_search == 'true'
    projects = projects.where('created_at > ?', start_date_search) if start_date_search.present?
    projects = projects.where('created_at < ?', end_date_search) if end_date_search.present?
    projects = projects.where("customer_id = ?", customer_id_search) if customer_id_search.present?
    projects
  end  
                 
end

 