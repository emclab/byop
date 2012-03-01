# encoding: utf-8
class Purchasing < ActiveRecord::Base
  attr_accessible :prod_name, :part_num, :spec, :project_id, :qty, :unit, :unit_price, :pur_eng_id, :manufacturer_id, :supplier_id,
                  :order_date, :delivery_date, :proj_module_id, :eng_id, 
                  :as => :role_new
  attr_accessible :prod_name, :part_num, :spec, :qty, :unit, :unit_price, :pur_eng_id, :manufacturer_id, :supplier_id, :eng_id, 
                  :order_date, :delivery_date, :proj_module_id, :delivered, :approved_by_eng, :approve_eng_id, :approve_date_eng,
                  :approved_by_vp_eng, :approve_vp_eng_id, :approve_date_vp_eng, :approved_by_pur_eng, :approve_pur_eng_id,
                  :approve_date_pur_eng, :approved_by_ceo, :approve_ceo_id, :approve_date_ceo,
                  :as => :role_update
                   
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
<<<<<<< HEAD
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
  
  validates :prod_name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates_numericality_of :project_id, :greater_than => 0
  validates_numericality_of :eng_id, :greater_than => 0
=======
  belongs_to :project
  has_many :purchasing_logs
  
  validates :prod_name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates_numericality_of :project_id, :greater_than => 0
  validates_numericality_of :pur_eng_id, :greater_than => 0
>>>>>>> 29060a9b49f5ea79a23abedfb3f82845dd44d786
  validates_numericality_of :manufacturer_id, :greater_than => 0
  validates :qty, :numericality => { :only_integer => true } 
  validates :unit, :presence => true
  validates :order_date, :presence => true
  validates :delivery_date, :presence => true
  validates :spec, :presence => true
end
