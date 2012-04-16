# encoding: utf-8
class ProjectsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_log_right?
  
  def index
    @title = '项目设备'
    if comp_sec? || vp_eng? || vp_sales? || ceo? || coo?
      @projects = Project.order("created_at DESC, completed DESC").paginate(:per_page => 40, :page => params[:page])    
    else
      @projects = Project.not_cancelled_project.order("created_at DESC").paginate(:per_page => 40, :page => params[:page])
    end
  end

  def new
    @title = '输入项目设备'
    @project = Project.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @project = Project.new(params[:project], :as => :role_new)
      @project.input_by_id = session[:user_id]
      if @project.save
        redirect_to URI.escape("/view_handler?index=0&msg=项目设备信息已保存！")
      else
        flash.now[:error] = '数据错误，无法保存！'
        render 'new'
      end
    end
  end

  def edit
    @title = '更改项目设备'
    @project = Project.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @project = Project.find(params[:id])
      @project.input_by_id = session[:user_id]
      if @project.update_attributes(params[:project], :as => :role_update)
        redirect_to URI.escape("/view_handler?index=0&msg=项目设备信息已更改！")
      else
        flash.now[:error] = '数据错误，无法保存!'
        render 'edit'
      end
    end
  end

  def show
    @title = '项目设备内容'
    @project = Project.find(params[:id])
    if !has_show_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end
  
  def cancel
    if ceo?
      @project = Project.find(params[:id])
      @project.update_attributes({:cancelled => true, :cancel_date => Time.now, :input_by_id => session[:user_id]},
                                 :as => :role_update ) 
    end
  end
  
  def re_activate
    if ceo?
      @project = Project.find(params[:id])
      @project.update_attributes({:cancelled => false, :cancel_date => Time.now, :input_by_id => session[:user_id]},
                                 :as => :role_update ) 
    end
  end  
      
  protected
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_create_right?
    comp_sec? || vp_sales? || coo? || ceo?
  end
  
  def has_update_right?
    inst_eng? || vp_eng? || comp_sec? || vp_sales? || coo? || ceo?
  end
  
  def has_log_right?
    comp_sec? || vp_sales? || coo? || ceo?
  end

end
