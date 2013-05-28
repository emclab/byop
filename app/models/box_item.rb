# encoding: utf-8
class BoxItem < ActiveRecord::Base
  attr_accessible :brief_note, :name, :qty, :shipment_item_id, :spec, :unit, :as => :role_new
  attr_accessible :brief_note, :name, :qty, :shipment_item_id, :spec, :unit, :as => :role_update
  
  belongs_to :input_by, :class_name => 'User' 
  belongs_to :shipment_item
  
  validates :name, :presence => true,
                   :uniqueness => {:scope => :shipment_item_id, :case_sensitive => false, :message => '货品重名！'}
  validates :spec, :presence => true
  validates_numericality_of :qty, :only_integer => true, :greater_than => 0
  validates :unit, :presence => true
end
