# encoding: utf-8
class Purchasing < ActiveRecord::Base
  
  attr_accessor   :project_id_search, :start_date_search, :end_date_search, :approved_by_eng_search, :approved_by_vp_eng_search, 
                  :approved_by_pur_eng_search, :approved_by_ceo_search, :mfg_id_search, :eng_id_search, :customer_id_search,
                  :supplier_id_search, :delivered_search, :time_frame
  
  attr_accessible :project_id_search, :start_date_search, :end_date_search, :approved_by_eng_search, :approved_by_vp_eng_search, 
                  :approved_by_pur_eng_search, :approved_by_ceo_search, :mfg_id_search, :eng_id_search, :customer_id_search,
                  :supplier_id_search, :delivered_search, :as => :role_search_stats
                    
  attr_accessible :prod_name, :part_num, :spec, :project_id, :qty, :unit, :unit_price, :pur_eng_id, :manufacturer_id, :supplier_id,
                  :order_date, :delivery_date, :proj_module_id, :eng_id, :total, 
                  :as => :role_new
  attr_accessible :prod_name, :part_num, :spec, :qty, :unit, :unit_price, :pur_eng_id, :manufacturer_id, :supplier_id, :eng_id, 
                  :order_date, :delivery_date, :proj_module_id, :delivered, :approved_by_eng, :approve_eng_id, :approve_date_eng,
                  :approved_by_vp_eng, :approve_vp_eng_id, :approve_date_vp_eng, :approved_by_pur_eng, :approve_pur_eng_id,
                  :approve_date_pur_eng, :approved_by_ceo, :approve_ceo_id, :approve_date_ceo, :total, :actual_receiving_date,
                  :stamped, 
                  :as => :role_update
                   
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :eng, :class_name => 'User', :foreign_key => "eng_id"
  belongs_to :pur_eng, :class_name => 'User', :foreign_key => 'pur_eng_id'
  belongs_to :approve_pur_eng, :class_name => 'User', :foreign_key => 'approve_pur_eng_id'
  belongs_to :approve_eng, :class_name => 'User', :foreign_key => 'approve_eng_id'
  belongs_to :approve_vp_eng, :class_name => 'User', :foreign_key => 'approve_vp_eng_id'
  belongs_to :approve_ceo, :class_name => 'User', :foreign_key => 'approve_ceo_id'
  belongs_to :project
  belongs_to :manufacturer
  belongs_to :supplier
  has_many :purchasing_logs
  has_many :proj_modules
  has_many :payment_logs
  
  validates :prod_name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates_numericality_of :project_id, :greater_than => 0
  validates_numericality_of :eng_id, :greater_than => 0
  validates_numericality_of :manufacturer_id, :greater_than => 0
  validates :qty, :numericality => { :only_integer => true } 
  validates :unit, :presence => true
  validates :order_date, :presence => true
  validates :delivery_date, :presence => true
  validates :spec, :presence => true
  
  def find_purchasings
    purchasings = Purchasing.where("purchasings.created_at > ?", 6.years.ago)
    purchasings = purchasings.where('order_date > ?', start_date_search) if start_date_search.present?
    purchasings = purchasings.where('order_date < ?', end_date_search) if end_date_search.present?
    purchasings = purchasings.where('project_id = ?', project_id_search) if project_id_search.present? 
    purchasings = purchasings.joins(:project).where('projects.customer_id = ?', customer_id_search) if customer_id_search.present?
    purchasings = purchasings.where('manufacturer_id = ?', mfg_id_search) if mfg_id_search.present? 
    purchasings = purchasings.where('supplier_id = ?', supplier_id_search) if supplier_id_search.present? 
    purchasings = purchasings.where('eng_id = ?', eng_id_search) if eng_id_search.present?
    purchasings = purchasings.where('purchasings.delivered = ?', true) if delivered_search.present? && delivered_search == 'true'
    purchasings = purchasings.where('purchasings.delivered = ? OR purchasings.delivered IS NULL', false) if delivered_search.present? && delivered_search == 'false'
    purchasings = purchasings.where('approved_by_eng = ?', true) if approved_by_eng_search.present? && approved_by_eng_search == 'true'
    purchasings = purchasings.where('approved_by_eng = ? OR approved_by_eng IS NULL', false) if approved_by_eng_search.present? && approved_by_eng_search == 'false'
    purchasings = purchasings.where('approved_by_vp_eng = ?', true) if approved_by_vp_eng_search.present? && approved_by_vp_eng_search == 'true'
    purchasings = purchasings.where('approved_by_vp_eng = ? OR approved_by_vp_eng IS NULL', false) if approved_by_vp_eng_search.present? && approved_by_vp_eng_search == 'false'
    purchasings = purchasings.where('approved_by_pur_eng = ?', true) if approved_by_pur_eng_search.present? && approved_by_pur_eng_search == 'true'
    purchasings = purchasings.where('approved_by_pur_eng = ? OR approved_by_pur_eng IS NULL', false) if approved_by_pur_eng_search.present? && approved_by_pur_eng_search == 'false'
    purchasings = purchasings.where('approved_by_ceo = ?', true) if approved_by_ceo_search.present? && approved_by_ceo_search == 'true'
    purchasings = purchasings.where('approved_by_ceo = ? OR approved_by_ceo IS NULL', false) if approved_by_ceo_search.present? && approved_by_ceo_search == 'false'
    purchasings
  end
  
end
