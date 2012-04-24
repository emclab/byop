# encoding: utf-8
class OutLog < ActiveRecord::Base
  attr_accessible :out_qty, :out_date, :for_what, :project_id, :receiver_id,
                  :as => :role_new
                   
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :receiver, :class_name => 'User'
  belongs_to :project, :class_name => 'Project'
  
  validates :out_date, :presence => true
  validates :receiver_id, :presence => true
  validates_numericality_of :out_qty, :only_integer => true, :greater_than => 0

end
