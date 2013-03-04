# encoding: utf-8
class InstallationPurchase < ActiveRecord::Base
  
  attr_accessor :installation_name, :total
  attr_accessible :installation_id, :applicant_id, :qty, :unit, :unit_price, :total, :for_what,
                  :part_name, :spec, :need_date, 
                  :as => :role_new
  attr_accessible :applicant_id, :qty, :unit, :unit_price, :total, :for_what, :need_date, 
                  :part_name, :spec, :total_paid, :purchased, :qty_purchased, :qty_in_stock,
                  :storage_location, 
                  :as => :role_update                  
  attr_accessible :approved_by_vp_eng, :approve_vp_eng_id, :approve_date_vp_eng, :approved_by_ceo,
                  :approve_by_ceo_id, :approve_date_ceo,
                  :as => :role_approve
                  
                   
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :applicant, :class_name => 'User'
  belongs_to :installation
  has_many :installation_purchase_logs
  
  validates :part_name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :spec, :presence => true
  validates :for_what, :presence => true
  validates_numericality_of :installation_id, :greater_than => 0
  validates_numericality_of :applicant_id, :greater_than => 0
  validates_numericality_of :unit_price, :greater_than => 0
  validates :need_date, :presence => true
  validates :qty, :presence => true, :numericality => {:only_integer => true}
  validates :qty_purchased, :numericality => {:only_integer => true }, :if => "purchased"
  validates :unit, :presence => true
  #validates :total, :presence => true
  validates_numericality_of :qty_in_stock, :greater_than => 0, :only_integer => true, :if => "purchased"
  validates_numericality_of :total_paid, :greater_than => 0, :if => "purchased"
end
