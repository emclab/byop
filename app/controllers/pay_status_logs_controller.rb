# encoding: utf-8
class PayStatusLogsController < ApplicationController
  before_filter :require_employee
  
  helper_method :has_create_right?
  
  def new
    @payment_log = PaymentLog.find_by_id(params[:payment_log_id])
    @pay_status_log = @payment_log.pay_status_logs.new
    unless has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    @payment_log = PaymentLog.find_by_id(params[:payment_log_id])
    @pay_status_log = @payment_log.pay_status_logs.new(params[:pay_status_log], :as => :role_new)
    if has_create_right?
      @pay_status_log.input_by_id = session[:user_id]
      if @pay_status_log.save
        redirect_to payment_log_path(@payment_log), :notice => "记录已保存！"
      else
        flash.now[:error] = "数据错误。无法保存记录！"
        render 'new'
      end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end
  
  protected
  
  def has_create_right?
    acct? || comp_sec? ||  pur_eng? || src_eng? || vp_eng? || ceo? || coo? || vp_sales?
  end
end
