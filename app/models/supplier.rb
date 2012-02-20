# encoding: utf-8
class Supplier < ActiveRecord::Base
  belongs_to :input_by, :class_name => 'User'
  has_many :projects
  has_many :customer
  
  attr_accessible :name, :short_name, :phone, :fax, :address, :contact, :cell, :customer_service, :quality_system,
                  :last_eval_date, :main_product, :eval_summary, :product_supplied, :web, :email, :supply_since,
                  :as => :role_new
  attr_accessible :name, :short_name, :phone, :fax, :address, :contact, :cell, :customer_service, :quality_system,
                  :last_eval_date, :main_product, :eval_summary, :product_supplied, :web, :email, :supply_since,
                  :active, 
                  :as => :role_update  

  validates :name, :presence => true, :uniqueness => true, :if => "active"
  validates :short_name, :presence => true, :uniqueness => true, :if => "active"
  validates :phone, :presence => true
  validates :fax, :presence => true
  validates :address, :presence => true
  validates :contact, :presence => true
  validates :cell, :presence => true
  validates :quality_system, :presence => true  
  validates :main_product, :presence => true                                 
                  
  scope :active_supplier, where(:active => true) 
  scope :inactive_supplier, where(:active => false)    
                      
end
