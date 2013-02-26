# encoding: utf-8
class Part < ActiveRecord::Base
  attr_accessor :total
  attr_accessible :in_qty, :unit, :name, :spec, :in_date, :stock_qty,:manufacturer, :inspection, :note, :storage_location, :supplier, :unit_price,
                  :as => :role_new
  attr_accessible :unit, :name, :spec, :stock_qty,:manufacturer, :inspection, :note, :storage_location, :supplier, :in_date, :unit_price,
                  :as => :role_update
                   
  #has_and_belongs_to_many :categories
  belongs_to :input_by, :class_name => 'User' 
  has_many :out_logs
  
  validates :name, :presence => true
  validates :spec, :presence => true
  validates_numericality_of :in_qty, :only_integer => true, :greater_than => 0
  validates_numericality_of :unit_price, :greater_than => 0, :message => '输入单价（非零）！'
  validates :unit, :presence => true
  validates_numericality_of :stock_qty, :less_than_or_equal_to => :in_qty, :if => Proc.new { |part| !part.in_qty.nil? }
  validates :stock_qty, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0}
  validates :in_date, :presence => true
  validates :storage_location, :presence => true

end
