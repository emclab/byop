# encoding: utf-8
class Sourcing < ActiveRecord::Base
  attr_accessible :prod_name, :part_num, :spec, :qty, :unit, :unit_price, :subsys_id, :src_plant_id, :start_date, :finish_date, :src_eng_id, :project_id, 
                  :as => :role_new
  attr_accessible :prod_name, :part_num, :spec, :qty, :unit, :unit_price, :subsys_id, :src_plant_id, :start_date, :finish_date, :src_eng_id,
                  :completed, :approved_by_vp_eng, :approve_vp_eng_id, :approve_date_vp_eng, :approved_by_ceo, :approve_ceo_id, :approve_date_ceo,
                  :as => :role_update
                   
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :project
  has_many :sourcing_logs
  
  validates :prod_name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates_numericality_of :project_id, :greater_than => 0
  validates_numericality_of :src_eng_id, :greater_than => 0
  validates :spec, :presence => true
  validates :qty, :numericality => { :only_integer => true } 
  validates :unit, :presence => true
  validates :start_date, :presence => true
  validates :finish_date, :presence => true
  
end
   