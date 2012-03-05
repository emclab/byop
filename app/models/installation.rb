# encoding: utf-8
class Installation < ActiveRecord::Base
  attr_accessible :install_name, :inst_eng_id, :project_id, :start_date, :finish_date, 
                  :as => :role_new
  attr_accessible :install_name, :inst_eng_id, :completed, :start_date, :finish_date, 
                  :as => :role_update
                   
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :inst_eng, :class_name => 'User'
  belongs_to :project
  has_many :installation_logs
  has_many :installation_purchases  
  
  validates :install_name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates_numericality_of :project_id, :greater_than => 0
  validates_numericality_of :inst_eng_id, :greater_than => 0
  validates :start_date, :presence => true
  validates :finish_date, :presence => true
end
