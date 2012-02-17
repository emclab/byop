# encoding: utf-8
require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password, :update_password_checkbox
  has_many :user_levels, :dependent => :destroy
  belongs_to :input_by, :class_name => "User"
  accepts_nested_attributes_for :user_levels, :reject_if => lambda { |a| a[:position].blank? }, :allow_destroy => true
  
 # attr_accessible :name, :login, :password, :user_type, :as => :role_new
  #attr_accessible :name, :login, :password, :user_status, :as => :role_update
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :login, :presence => true,
                    :length   => {:within => 6..10}
  validates :email, :format     => { :with => email_regex, :message => '电邮格式错误！' , :if => :check_email },
                    :uniqueness => { :scope => :status, :case_sensitive => false, :if => :check_email, :message => '电邮已占用！' }
                    
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 },
                       :if => :validate_password?                      
  validates :user_type,  :presence => true  
  validates_presence_of :status, :inclusion => {:in => %w(active blocked inactive), :message => '用户状态不存在！'}
  validates_numericality_of :input_by_id, :greater_than => 0
                       
  validates_associated :user_levels

  before_save :encrypt_password

  scope :user_status, lambda { |us| where('status = ?', us) }
  scope :user_type, lambda { |ut| where('user_type = ?', ut) }

  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  class << self
    def authenticate(login, submitted_password)
      user = find_by_login(login)
      (user && user.has_password?(submitted_password)) ? user : nil
    end
    
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end
   
  private
  
  def validate_password?
    # true when checked
    update_password_checkbox == '1' || self.new_record?  
  end
  
  def check_email
    return false if email.nil?
    return false if status != 'active'  
    true
  end
  
  def encrypt_password
    self.salt = make_salt if new_record?
    self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)
    secure_hash("#{salt}--#{string}")
  end
    
  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end
    
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
          
end
