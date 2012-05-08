# encoding: utf-8
class ProductionLogsController < ApplicationController

  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?

  def index
    @title= "生产计划Log"   
    @production = Production.find(params[:production_id])
    @production_logs = @production.production_logs
  end

      
  def new
    @title= "输入Log"   
    @production = Production.find(params[:production_id])
    @production_log = @production.production_logs.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @production = Production.find(params[:production_id])
      @production_log = @production.production_logs.new(params[:production_log], :as => :role_new)
      @production_log.input_by_id = session[:user_id]
      if @production_log.save
        redirect_to production_path(@production), :notice => "Log已保存！"
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
