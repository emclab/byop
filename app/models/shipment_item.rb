class ShipmentItem < ActiveRecord::Base
  attr_accessible :boxed, :brief_note, :name, :qty, :shipment_id, :spec, :unit, :as => :role_new
  attr_accessible :boxed, :brief_note, :name, :qty, :spec, :unit, :as => :role_update
  
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :shipment
  has_many :box_items
  
  validates :name, :presence => true
  validates :spec, :presence => true
  validates_numericality_of :qty, :only_integer => true, :greater_than => 0
  validates :unit, :presence => true
end
