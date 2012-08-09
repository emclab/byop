# encoding: utf-8
class SourcingLogsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?

  def index
    @title= "外协计划Log"   
    @sourcing = Sourcing.find(params[:sourcing_id])
    @sourcing_logs = @sourcing.sourcing_logs.order("id DESC")
  end

      
  def new
    @title= "输入Log"   
    @sourcing = Sourcing.find(params[:sourcing_id])
    @sourcing_log = @sourcing.sourcing_logs.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @sourcing = Sourcing.find(params[:sourcing_id])
      @sourcing_log = @sourcing.sourcing_logs.new(params[:sourcing_log], :as => :role_new)
      @sourcing_log.input_by_id = session[:user_id]
      if @sourcing_log.save
        redirect_to project_sourcing_path(@sourcing.project, @sourcing), :notice => "Log已保存！"
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
    is_tech_eng? || vp_eng? || vp_sales? || comp_sec? || coo? || ceo?
  end

end
