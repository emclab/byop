# encoding: utf-8
class Manufacturer < ActiveRecord::Base
  belongs_to :input_by, :class_name => 'User'

  attr_accessible :name, :product, :as => :role_new
  attr_accessible :name, :product, :as => :role_update
  
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  
end
