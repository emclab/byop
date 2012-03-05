# encoding: utf-8
class SourcingsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_log_right?,
                :need_approve?
  
  def index
    @title = '外协计划'
    @project = Project.find(params[:project_id])
    @sourcings = @project.sourcings.order("completed, start_date, finish_date")   
  end

  def new
    @title = '输入计划'
    @project = Project.find(params[:project_id])
    @sourcing = @project.sourcings.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @project = Project.find(params[:project_id])
      @sourcing = @project.sourcings.new(params[:sourcing], :as => :role_new)
      @sourcing.input_by_id = session[:user_id]
      if @sourcing.save
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
    @sourcing = @project.sourcings.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @project = Project.find(params[:project_id])
      @sourcing = @project.sourcings.find(params[:id])
      @sourcing.input_by_id = session[:user_id]
      if @sourcing.update_attributes(params[:sourcing], :as => :role_update)
        redirect_to URI.escape("/view_handler?index=0&msg=计划已更改！")
      else
        flash.now[:error] = '数据错误，无法保存!'
        render 'edit'
      end
    end
  end

  def show
    @title = '外协计划内容'
    @project = Project.find(params[:project_id])
    @sourcing = @project.sourcings.find(params[:id])
    if !has_show_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def approve
    
    @project = Project.find(params[:project_id])
    @sourcing = @project.sourcings.find(params[:id])
    if need_approve?(@sourcing)  
      if vp_eng?
        @sourcing.update_attributes!(:approved_by_vp_eng => true, :approve_vp_eng_id => session[:user_id],
                                    :approve_date_vp_eng => Date.today, :as => :role_update) 
     
      elsif ceo?
        @sourcing.update_attributes(:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                    :approve_date_ceo => Time.now, :as => :role_update) 
      end
    
      redirect_to project_sourcing_path(@project, @sourcing)
    else
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足!")    
    end
  end
    
  protected
  
  def need_approve?(sourcing)
    if vp_eng? && !sourcing.approved_by_ceo
      return true
    elsif ceo? && sourcing.approved_by_vp_eng 
      return true
    end
    return false
  end  
  
  def has_approve_right?
    vp_eng? || ceo?
  end
    
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
    src_eng? || vp_eng? || comp_sec? || vp_sales? || coo? || ceo?
  end


end
