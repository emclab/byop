# encoding: utf-8
class ProjectsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_log_right?, :has_search_right?, :has_stats_right?, :is_project_manager?
  
  def index
    @title = '项目设备'
    if comp_sec? || vp_eng? || vp_sales? || ceo? || coo?
      @projects = Project.order("id DESC, created_at DESC, completed ASC").paginate(:per_page => 40, :page => params[:page])    
    else
      @projects = Project.not_cancelled_project.order("id DESC").paginate(:per_page => 40, :page => params[:page])
    end
  end

  def new
    @title = '输入项目设备'
    @project = Project.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @project = Project.new(params[:project], :as => :role_new)
      @project.input_by_id = session[:user_id]
      if @project.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=项目设备信息已保存！")
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
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @project = Project.find(params[:id])
      @project.input_by_id = session[:user_id]
      if @project.update_attributes(params[:project], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=项目设备信息已更改！")
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
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
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
  
  def search
    if has_search_right?
      @project = Project.new
    end
  end
  
  def search_results
    if has_search_right?
      @project = Project.new(params[:project], :as => :role_search_stats)
      @projects = @project.find_projects
      #seach params
      @search_params = search_params()
    end
  end
  
  def stats
    if has_stats_right?
      @project = Project.new
    end
  end
  
  def stats_results
    if has_stats_right?
      @project = Project.new(params[:project], :as => :role_search_stats)
      @project_stats = @project.find_projects
      #retrieve parameter
      @stats_params = "参数：" + params[:project][:time_frame] + '，统计条数：' + @project_stats.count.to_s 
      group_records(params[:project][:time_frame]) #result in @lease_usage_record_stats & @stats_params
      @stats_params += ', ' + Customer.find_by_id(params[:project][:customer_id_search]).short_name if params[:project][:customer_id_search].present?
      @stats_params += ', 签了？：' + params[:project][:awarded_search] if params[:project][:awarded_search].present?
      @stats_params += ', 取消？：' + params[:project][:cancelled_search] if params[:project][:cancelled_search].present?
      @stats_params += ', 完成？：' + params[:project][:completed_search] if params[:project][:completed_search].present?
      return if @project_stats.blank?  #empty record causes error in following code      
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无统计权限！")      
    end
  end
      
  protected
  
  def has_search_right?
    comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_stats_right?
    vp_sales? || coo? || ceo?
  end
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_create_right?
    comp_sec? || vp_sales? || coo? || ceo?
  end
  
  def has_update_right?
    inst_eng? || vp_eng? || comp_sec? || vp_sales? || coo? || ceo?
  end
  
  def is_project_manager?(project)
    project.project_manager_id == session[:user_id] 
  end
  
  def has_log_right?
    comp_sec? || vp_sales? || coo? || ceo?
  end
  
  def search_params
    search_params = "参数："
    search_params += ' 开始日期：' + params[:project][:start_date_search] if params[:project][:start_date_search].present?
    search_params += ', 结束日期：' + params[:project][:end_date_search] if params[:project][:end_date_search].present?
    search_params += ', 项目签了？ ：' + params[:project][:awarded_search] if params[:project][:awarded_search].present?
    search_params += ', 项目取消？ ：' + params[:project][:cancelled_search] if params[:project][:cancelled_search].present?
    search_params += ', 项目完成？ ：' + params[:project][:completed_search] if params[:project][:completed_search].present?
    search_params += ', 客户 ：' + Customer.find_by_id(params[:project][:customer_id_search].to_i).short_name if params[:project][:customer_id_search].present?
    search_params
  end

  def group_records(time_frame)
      case time_frame #params[:lease_usage_record][:time_frame]
      when '周'
        @project_stats = @project_stats.where("created_at > ?", 2.years.ago).all(:select => "created_at, sum(budget) as revenue, count(DISTINCT(customer_id)) as num_customer", 
                                :group => "strftime('%Y/%W', created_at)")
                          
      when '月'
        @project_stats = @project_stats.where("created_at > ?", 3.years.ago).all(:select => "created_at, sum(budget) as revenue, count(DISTINCT(customer_id)) as num_customer", 
                                :group => "strftime('%Y/%m', created_at)")                     
      when '季'
        @project_stats = @project_stats.where("created_at > ?", 4.years.ago).all(:select => "created_at, sum(budget) as revenue, count(DISTINCT(customer_id)) as num_customer,
                                CASE WHEN cast(strftime('%m', created_at) as integer) BETWEEN 1 AND 3 THEN 1 WHEN cast(strftime('%m', created_at) as integer) BETWEEN 4 and 6 THEN 2 WHEN cast(strftime('%m', created_at) as integer) BETWEEN 7 and 9 THEN 3 ELSE 4 END as quarter", 
                                :group => "strftime('%Y', created_at), quarter")                                
      when '年'
        @project_stats = @project_stats.where("created_at > ?", 5.years.ago).all(:select => "created_at, sum(budget) as revenue, count(DISTINCT(customer_id)) as num_customer",
                                :group => "strftime('%Y', created_at)")     
      end   

  end
end
