# encoding: utf-8
class PaymentLog < ActiveRecord::Base
  
  belongs_to :purchasing
  belongs_to :sourcing
  belongs_to :input_by, :class_name => 'User'
  
  attr_accessible :pay_date, :amount, :short_note, :as => :role_new_update
  
  attr_accessor :project_id_search, :purchasing_id_search, :sourcing_id_search, :start_date_search, :end_date_search,
                :src_plant_id_search, :supplier_id_search, :for_search
  attr_accessible :project_id_search, :purchasing_id_search, :sourcing_id_search, :start_date_search, :end_date_search,
                  :src_plant_id_search, :supplier_id_search, :for_search, 
                  :as => :role_search_stats
  
  validates :pay_date, :presence => true
  
  def find_payment_logs
    payment_logs = PaymentLog.where("payment_logs.pay_date > ?", 1000.days.ago)
    payment_logs = payment_logs.where("payment_logs.pay_date > ?", start_date_search) if start_date_search.present?
    payment_logs = payment_logs.where("payment_logs.pay_date < ?", end_date_search) if end_date_search.present?   
    payment_logs = payment_logs.where("payment_logs.purchasing_id IS NOT NULL") if for_search.present? && for_search == '外购'
    payment_logs = payment_logs.where("payment_logs.sourcing_id IS NOT NULL") if for_search.present? && for_search == '外协'
    payment_logs = payment_logs.where(["
            payment_logs.sourcing_id IN   (
                                           SELECT id FROM sourcings WHERE sourcings.project_id = ? 
                                          ) 
         OR payment_logs.purchasing_id IN (
                                           SELECT id FROM purchasings WHERE purchasings.project_id = ? 
                                          )", project_id_search, project_id_search]) if project_id_search.present?
    payment_logs = payment_logs.joins(:sourcing).where("sourcings.src_plant_id = ?", src_plant_id_search) if src_plant_id_search.present?
    payment_logs = payment_logs.joins(:purchasing).where("purchasings.supplier_id = ?", supplier_id_search) if supplier_id_search.present?
    payment_logs = payment_logs.order("purchasing_id DESC, sourcing_id DESC, pay_date DESC")
    payment_logs
  end
  
end
