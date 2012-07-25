# encoding: utf-8
class Sourcing < ActiveRecord::Base
  
  attr_accessor   :project_id_search, :start_date_search, :end_date_search, :approved_by_vp_eng_search, :completed_search,
                  :approved_by_ceo_search, :eng_id_search, :src_plant_id_search, :src_eng_id_search, :customer_id_search
                  
  
  attr_accessible :project_id_search, :start_date_search, :end_date_search,  :approved_by_vp_eng_search, :completed_search,
                  :approved_by_ceo_search, :eng_id_search, :src_plant_id_search, :src_eng_id_search, :customer_id_search,
                  :as => :role_search_stats
                  
  attr_accessible :prod_name, :part_num, :spec, :qty, :unit, :unit_price, :proj_module_id, :src_plant_id, :start_date, :finish_date, :src_eng_id, :project_id, :total,
                  :as => :role_new
  attr_accessible :prod_name, :part_num, :spec, :qty, :unit, :unit_price, :proj_module_id, :src_plant_id, :start_date, :finish_date, :src_eng_id,
                  :completed, :approved_by_vp_eng, :approve_vp_eng_id, :approve_date_vp_eng, :approved_by_ceo, :approve_ceo_id, :total, :src_plant_id,
                  :approve_date_ceo, :as => :role_update                 
                  
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :eng, :class_name => 'User'
  belongs_to :src_eng, :class_name => 'User'
  belongs_to :src_plant, :class_name => 'SrcPlant'
  belongs_to :approve_vp_eng, :class_name => 'User', :foreign_key => 'approve_vp_eng_id'
  belongs_to :approve_ceo, :class_name => 'User', :foreign_key => 'approve_ceo_id'  
  belongs_to :project
  has_many :sourcing_logs
  has_many :proj_modules
  
  validates :prod_name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates_numericality_of :project_id, :greater_than => 0
  validates :spec, :presence => true
  validates :qty, :numericality => { :only_integer => true } 
  validates :unit, :presence => true
  validates :start_date, :presence => true
  validates :finish_date, :presence => true
  
  def find_sourcings
    sourcings = Sourcing.where("sourcings.created_at > ?", 6.years.ago)
    sourcings = sourcings.where('start_date > ?', start_date_search) if start_date_search.present?
    sourcings = sourcings.where('start_date < ?', end_date_search) if end_date_search.present?
    sourcings = sourcings.joins(:project).where('projects.customer_id = ?', customer_id_search) if customer_id_search.present?
    sourcings = sourcings.where('project_id = ?', project_id_search) if project_id_search.present? 
    sourcings = sourcings.where('src_plant_id = ?', src_plant_id_search) if src_plant_id_search.present? 
    sourcings = sourcings.where('eng_id = ?', eng_id_search) if eng_id_search.present?
    sourcings = sourcings.where('src_eng_id = ?', src_eng_id_search) if src_eng_id_search.present?
    sourcings = sourcings.where('sourcings.completed = ?', true) if completed_search.present? && completed_search == 'true'
    sourcings = sourcings.where('sourcings.completed = ? OR sourcings.completed IS NULL', false) if completed_search.present? && completed_search == 'false'    
    sourcings = sourcings.where("approved_by_vp_eng = ?", true) if approved_by_vp_eng_search.present? && approved_by_vp_eng_search == 'true'
    sourcings = sourcings.where('approved_by_vp_eng = ? OR approved_by_vp_eng IS NULL', false) if approved_by_vp_eng_search.present? && approved_by_vp_eng_search == 'false'
    sourcings = sourcings.where('approved_by_ceo = ?', true) if approved_by_ceo_search.present? && approved_by_ceo_search == 'true'
    sourcings = sourcings.where('approved_by_ceo = ? OR approved_by_ceo IS NULL', false) if approved_by_ceo_search.present? && approved_by_ceo_search == 'false'
    sourcings
  end
  
end
   