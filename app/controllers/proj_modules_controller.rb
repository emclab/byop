# encoding: utf-8
class ProjModulesController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee

  helper_method :has_create_right?
  
  def new
    @title = "输入分系统"    
    if has_create_right?
      @project = Project.find(params[:project_id])
      @proj_module = @project.proj_modules.new()
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @project = Project.find(params[:project_id])
      @proj_module = @project.proj_modules.new(params[:proj_module], :as => :role_new)
      @proj_module.input_by_id = session[:user_id]
      if @proj_module.save
        redirect_to project_path(@project)
      else
        flash.now[:error] = "无法保存！"
        render 'new'
      end
    end
  end

  protected
  
  def has_create_right?
    vp_eng?
  end
end
