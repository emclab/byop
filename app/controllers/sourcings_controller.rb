# encoding: utf-8
class SourcingsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_log_right?,
                :need_approve?, :has_stats_right?
  
  def index
    @title = '外协计划'
    @project = Project.find(params[:project_id])
    @sourcings = @project.sourcings.order("completed, created_at DESC, start_date, finish_date").paginate(:per_page => 40, :page => params[:page])    
  end

  def new
    @title = '输入计划'
    @project = Project.find(params[:project_id])
    @sourcing = @project.sourcings.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @project = Project.find(params[:project_id])
      @sourcing = @project.sourcings.new(params[:sourcing], :as => :role_new)
      @sourcing.input_by_id = session[:user_id]
      if @sourcing.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=计划已保存！")
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
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @project = Project.find(params[:project_id])
      @sourcing = @project.sourcings.find(params[:id])
      @sourcing.input_by_id = session[:user_id]
      if @sourcing.update_attributes(params[:sourcing], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=计划已更改！")
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
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def approve
    
    @project = Project.find(params[:project_id])
    @sourcing = @project.sourcings.find(params[:id])
    if need_approve?(@sourcing)  
      if vp_eng?
        @sourcing.update_attributes({:approved_by_vp_eng => true, :approve_vp_eng_id => session[:user_id],
                                       :approve_date_vp_eng => Time.now}, :as => :role_update)

      elsif ceo?
        @sourcing.update_attributes({:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                    :approve_date_ceo => Time.now}, :as => :role_update) 
      end
    
      redirect_to project_sourcing_path(@project, @sourcing)
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!")    
    end
  end

  def dis_approve
    
    @project = Project.find(params[:project_id])
    @sourcing = @project.sourcings.find(params[:id])
    if need_approve?(@sourcing)  
      if vp_eng?
        @sourcing.update_attributes({:approved_by_vp_eng => false, :approve_vp_eng_id => session[:user_id],
                                       :approve_date_vp_eng => Time.now}, :as => :role_update)

      elsif ceo?
        @sourcing.update_attributes({:approved_by_ceo => false, :approve_ceo_id => session[:user_id],
                                    :approve_date_ceo => Time.now}, :as => :role_update) 
      end
    
      redirect_to project_sourcing_path(@project, @sourcing)
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!")    
    end
  end

  def re_approve
    
    @project = Project.find(params[:project_id])
    @sourcing = @project.sourcings.find(params[:id])
    if ceo?  
      @sourcing.update_attributes({:approved_by_vp_eng => nil, :approve_vp_eng_id => nil, :approve_date_vp_eng => nil, 
                                   :approved_by_ceo => nil, :approve_ceo_id => nil, :approve_date_ceo => nil},
                                   :as => :role_update)
    
      redirect_to project_sourcing_path(@project, @sourcing)
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!")    
    end
  end
  
  def search
    @sourcing = Sourcing.new
  end

  def search_results
    @sourcing = Sourcing.new(params[:sourcing], :as => :role_search_stats)
    @sourcings = @sourcing.find_sourcings.order("project_id DESC, created_at DESC, start_date") #.paginate(:per_page => 40, :page => params[:page])
    #seach params
    @search_params = search_params()
  end  
        
  protected
  
  def need_approve?(sourcing)
    if vp_eng? && sourcing.approved_by_ceo.nil?
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

  def has_stats_right?  #show stats on search page
    vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def search_params
    search_params = "参数："
    search_params += ' 开始日期：' + params[:sourcing][:start_date_search] if params[:sourcing][:start_date_search].present?
    search_params += ', 结束日期：' + params[:sourcing][:end_date_search] if params[:sourcing][:end_date_search].present?
    search_params += ', 客户 ：' + Customer.find_by_id(params[:sourcing][:customer_id_search].to_i).short_name if params[:sourcing][:customer_id_search].present? 
    search_params += ', 项目 ：' + Project.find_by_id(params[:sourcing][:project_id_search].to_i).name if params[:sourcing][:project_id_search].present?   
    search_params += ', 工程师：' + User.find_by_id(params[:sourcing][:eng_id_search].to_i).name if params[:sourcing][:eng_id_search].present?
    search_params += ', 外协工程师：' + User.find_by_id(params[:sourcing][:src_eng_id_search].to_i).name if params[:sourcing][:src_eng_id_search].present?
    search_params += ', 外协厂：' + SrcPlant.find_by_id(params[:sourcing][:src_plant_id_search].to_i).name if params[:sourcing][:src_plant_id_search].present?
    search_params += ', 完成？ ：' + params[:sourcing][:completed_search] if params[:sourcing][:completed_search].present?
    search_params += ', 副总批了？ ：' + params[:sourcing][:approved_by_vp_eng_search] if params[:sourcing][:approved_by_vp_eng_search].present?
    search_params += ', 厂长批了？ ：' + params[:sourcing][:approved_by_ceo_search] if params[:sourcing][:approved_by_ceo_search].present?
    search_params
  end
  
end
