# encoding: utf-8
class PaymentLogsController < ApplicationController
  before_filter :require_employee  
  before_filter :load_sourcing
  before_filter :load_purchasing
  
  helper_method :has_index_right?, :has_create_right?, :has_update_right?
    
  def index
    if has_index_right?
      @payment_logs =
        if @sourcing
          @sourcing.payment_logs.where("pay_date > ? AND amount > ?", 900.days.ago, 0.00).order("pay_date DESC").paginate(:per_page => 40, :page => params[:page])
        elsif @purchasing
          @purchasing.payment_logs.where("pay_date > ? AND amount > ?", 900.days.ago, 0.00).order("pay_date DESC").paginate(:per_page => 40, :page => params[:page])
        else
          PaymentLog.where("pay_date > ? AND amount > ?", 900.days.ago, 0.00).order("purchasing_id DESC, sourcing_id DESC, pay_date DESC").paginate(:per_page => 40, :page => params[:page])
        end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！") 
    end
  end

  def new
    @payment_log = PaymentLog.new
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    @payment_log = PaymentLog.new(params[:payment_log], :as => :role_new_update)
    if has_create_right?
      @payment_log.input_by_id = session[:user_id]
      if @purchasing
        @payment_log.purchasing_id = @purchasing.id
      elsif @sourcing
        @payment_log.sourcing_id = @sourcing.id
      end
      if @payment_log.save
        redirect_to purchasing_payment_logs_path(@purchasing), :notice =>'记录已保存！' if @purchasing.present?
        redirect_to sourcing_payment_logs_path(@sourcing), :notice =>'记录已保存！' if @sourcing.present?
      end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def edit
    if has_update_right?
      @payment_log = PaymentLog.find(params[:id])
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @payment_log = PaymentLog.find(params[:id])
      if @payment_log.update_attributes(params[:payment_log], :as => :role_new_update)
        redirect_to purchasing_payment_logs_path(@purchasing), :notice =>'记录已更改！' if @purchasing.present?
        redirect_to sourcing_payment_logs_path(@sourcing), :notice =>'记录已更改！' if @sourcing.present?        
      end
    end
  end

 
  protected
  
  def has_index_right?
    acct? || comp_sec? || pur_eng? || src_eng? || coo? || vp_eng? || vp_sales? || ceo?
  end
  
  def has_create_right?
    acct? || comp_sec? || pur_eng? || src_eng? || coo? || vp_eng? || vp_sales? || ceo?
  end
  
  def has_update_right?
    acct? || comp_sec? || pur_eng? || src_eng? || coo? || vp_eng? || vp_sales? || ceo?
  end
  
  def load_sourcing
    @sourcing = Sourcing.find(params[:sourcing_id]) if params[:sourcing_id].present?
  end

  def load_purchasing
    @purchasing = Purchasing.find(params[:purchasing_id]) if params[:purchasing_id].present?
  end
end
