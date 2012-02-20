# encoding: utf-8
class Customer < ActiveRecord::Base
  attr_accessible :name, :short_name, :contact_info, :phone, :fax, :address, :quality_system, 
                  :employee_num, :main_biz, :equip_by_by, :installed_equip, :active,
                  :revenue, :note, :email, :country, :web, :quality_system, 
                  :as => :role_new_update
 
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
  has_many :projects
  has_many :comm_logs
  
  email_regexp = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name, :presence => true, :uniqueness => { :scope => :active , :case_sensitive => false }
  validates :short_name, :presence => true, :uniqueness => { :scope => :active, :case_sensitive => false }
  validates :contact_info, :presence => true
  validates :main_biz, :presence => true
  validates_inclusion_of :active, :in => [true, false]
  validates :email, :presence => true, :format => {:with => email_regexp}, :uniqueness => { :scope => :active }, :if => "active"
  validates :phone, :presence => true
  validates :address, :presence => true

  
  scope :active_cust, where(:active => true)
  scope :inactive_cust, where(:active => false)
  
  
end
