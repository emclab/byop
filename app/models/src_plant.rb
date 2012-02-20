# encoding: utf-8
class SrcPlant < ActiveRecord::Base  
  belongs_to :input_by, :class_name => 'User'
  has_many :projects
  has_many :customers
  
  attr_accessible :name, :short_name, :phone, :fax, :address, :primary_contact, :primary_cell, :tech_contact,
                  :tech_cell, :equip, :tech_ability, :customer_service, :production_capacity, :last_eval_date,
                  :eval_summary, :employee_num, :revenue, :about_us, :sourced_product, :web, :quality_system,
                  :email, :src_since, :main_product,
                  :as => :role_new
  attr_accessible :name, :short_name, :phone, :fax, :address, :primary_contact, :primary_cell, :tech_contact,
                  :tech_cell, :equip, :tech_ability, :customer_service, :production_capacity, :last_eval_date,
                  :eval_summary, :employee_num, :revenue, :about_us, :sourced_product, :web, :quality_system,
                  :email, :src_since, :active, :main_product,
                  :as => :role_update
  
  validates :name, :presence => true, :uniqueness => true, :if => "active"
  validates :short_name, :presence => true, :uniqueness => true, :if => "active"
  validates :phone, :presence => true
  validates :fax, :presence => true
  validates :address, :presence => true
  validates :primary_contact, :presence => true
  validates :primary_cell, :presence => true
  validates :quality_system, :presence => true
  validates :equip, :presence => true
  validates :tech_ability, :presence => true
  validates :main_product, :presence => true
                                    
  scope :active_plant, where(:active => true) 
  scope :inactive_plant, where(:active => false)    
end
