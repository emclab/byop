# encoding: utf-8
class QualityIssuesController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  before_filter :load_project
    
  helper_method :has_show_right?, :has_create_right?, :has_update_right?, :has_close_right?
  
  def index
    @title = '项目质量问题'
    @quality_issues = @project.present? ? @project.quality_issues.order("report_date DESC, project_id DESC").paginate(:per_page => 40, :page => params[:page]) : QualityIssue.where('created_at > ?', Time.now - 1000.day).order("report_date DESC, project_id DESC").paginate(:per_page => 40, :page => params[:page])        
  end

  def new
    @title = '输入质量问题'
    @project = Project.find(params[:project_id])
    @quality_issue = @project.quality_issues.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @project = Project.find(params[:project_id])
      @quality_issue = @project.quality_issues.new(params[:quality_issue], :as => :role_new)
      @quality_issue.input_by_id = session[:user_id]
      if @quality_issue.save
        redirect_to URI.escape("/view_handler?index=0&msg=质量问题已保存！")
      else
        flash.now[:error] = '数据错误，无法保存！'
        render 'new'
      end
    end
  end

  def edit
    @title = '修改质量问题'
    @project = Project.find(params[:project_id])
    @quality_issue = @project.quality_issues.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @project = Project.find(params[:project_id])
      @quality_issue = @project.quality_issues.find(params[:id])
      @quality_issue.input_by_id = session[:user_id]
      if @quality_issue.update_attributes(params[:quality_issue], :as => :role_update)
        redirect_to URI.escape("/view_handler?index=0&msg=质量问题已更改！")
      else
        flash.now[:error] = '数据错误，无法保存!'
        render 'edit'
      end
    end
  end

  def show
    @title = '质量问题内容'
    @project = Project.find(params[:project_id])
    @quality_issue = @project.quality_issues.find(params[:id]) 
    if !has_show_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")           
    end
  end

  protected
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_create_right?
    is_tech_eng? || vp_eng? || ceo?
  end
  
  def has_update_right?
    is_tech_eng? || vp_eng? || ceo?
  end
  
  def has_close_right?
    vp_eng? || ceo?
  end
    
  def load_project
    @project = Project.find(params[:project_id]) if params[:project_id].present?
  end  

end
