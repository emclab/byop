# encoding: utf-8
class Production < ActiveRecord::Base
  attr_accessible :name, :eng_id, :project_id, :start_date, :finish_date, 
                  :as => :role_new
  attr_accessible :name, :eng_id, :completed, :start_date, :finish_date,
                  :as => :role_update
                   
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :eng, :class_name => 'User'
  belongs_to :project
  has_many :production_logs
  
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates_numericality_of :project_id, :greater_than => 0
  validates_numericality_of :eng_id, :greater_than => 0
  validates :start_date, :presence => true
  validates :finish_date, :presence => true

end
