class Shipment < ActiveRecord::Base
  attr_accessor :customer_name, :project_name, :approved_by_ceo_noupdate, :approve_ceo_id_noupdate, :approve_date_ceo_noupdate
  attr_accessible :customer_signature_by, :delivery_date, :freight_desp, :project_id, :shipping_date, :shipping_via, :status, :shipment_items_attributes,
                  :delivery_address, :weight, :packing_desp, :cancelled, :as => :role_new
  attr_accessible :customer_signature_by, :delivery_date, :freight_desp, :shipping_date, :shipping_via, :status, :shipment_items_attributes, 
                  :delivery_address, :weight, :packing_desp, :cancelled, :as => :role_update
  
  attr_accessible :approved_by_ceo, :approve_ceo_id, :approve_date_ceo, :as => :role_approve
  
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :project
  has_many :shipment_items
  accepts_nested_attributes_for :shipment_items
  
  validates :shipping_date, :presence => true
  validates :shipping_via, :presence => true
  validates :freight_desp, :presence => true
  validates_numericality_of :project_id, :only_integer => true, :greater_than => 0
  validates :delivery_address, :presence => true
   
end
