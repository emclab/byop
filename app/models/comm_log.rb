# encoding: utf-8
class CommLog < ActiveRecord::Base
  belongs_to :customer
  belongs_to :input_by, :class_name => 'User'
   
  attr_accessible :subject, :log, :via, :purpose, :contact_with, :customer_id, :as => :role_new
  
  validates :subject, :presence => true
  validates :log, :presence => true
  validates :via, :presence => true
  validates :purpose, :presence => true
  validates :contact_with, :presence => true  
end
