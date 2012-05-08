# encoding: utf-8
class PurchasingLogsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?

  def index
    @title= "外购计划Log"   
    @purchasing = Purchasing.find(params[:purchasing_id])
    @purchasing_logs = @purchasing.purchasing_logs
  end

      
  def new
    @title= "输入Log"   
    @purchasing = Purchasing.find(params[:purchasing_id])
    @purchasing_log = @purchasing.purchasing_logs.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @purchasing = Purchasing.find(params[:purchasing_id])
      @purchasing_log = @purchasing.purchasing_logs.new(params[:purchasing_log], :as => :role_new)
      @purchasing_log.input_by_id = session[:user_id]
      if @purchasing_log.save
        redirect_to purchasing_path(@purchasing), :notice => "Log已保存！"
      else
        flash.now[:error] = "无法保存Log！"
        render 'new'
      end     
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")    
    end
  end

  protected
  
  def has_create_right?
    is_eng? || vp_eng? || comp_sec? || coo? || vp_sales? || ceo?
  end
  
end
