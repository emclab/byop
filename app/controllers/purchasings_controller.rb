# encoding: utf-8
class PurchasingsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_log_right?
  
  def index
    @title = '外购计划'
    @project = Project.find(params[:project_id])
    @purchasings = @project.purchasings.order("completed, start_date, finish_date")   
  end

  def new
    @title = '输入计划'
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @project = Project.find(params[:project_id])
      @purchasing = @project.purchasings.new(params[:purchasing], :as => :role_new)
      @purchasing.input_by_id = session[:user_id]
      if @purchasing.save
        redirect_to URI.escape("/view_handler?index=0&msg=计划已保存！")
      else
        flash.now[:error] = '数据错误，无法保存！'
        render 'new'
      end
    end
  end

  def edit
    @title = '更改计划'
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @project = Project.find(params[:project_id])
      @purchasing = @project.purchasings.find(params[:id])
      @purchasing.input_by_id = session[:user_id]
      if @purchasing.update_attributes(params[:purchasing], :as => :role_update)
        redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
      else
        flash.now[:error] = '数据错误，无法保存!'
        render 'edit'
      end
    end
  end

  def show
    @title = '外购计划内容'
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if !has_show_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end
  
  protected
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_create_right?
    vp_eng? || ceo?
  end
  
  def has_update_right?
    vp_eng? || ceo?
  end
  
  def has_log_right?
    pur_eng? || vp_eng? || comp_sec? || vp_sales? || coo? || ceo?
  end


end
