# encoding: utf-8
class PurchasingsController < ApplicationController
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_log_right?,
                :need_approve?
                
  def index
    @title = '外购计划'
    @project = Project.find(params[:project_id])
    @purchasings = @project.purchasings.order("delivered, order_date, delivery_date").paginate(:per_page => 40, :page => params[:page])    
  end

  def new
    @title = '输入计划'
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @project = Project.find(params[:project_id])
      @purchasing = @project.purchasings.new(params[:purchasing], :as => :role_new)
      @purchasing.input_by_id = session[:user_id]
      if @purchasing.save
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
    @purchasing = @project.purchasings.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @project = Project.find(params[:project_id])
      @purchasing = @project.purchasings.find(params[:id])
      @purchasing.input_by_id = session[:user_id]
      if @purchasing.update_attributes(params[:purchasing], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=计划已更改！")
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
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end
  
  def approve
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if need_approve?(@purchasing)
      if is_tech_eng? && @purchasing.eng_id == session[:user_id]
        @purchasing.update_attributes({:approved_by_eng => true, :approve_eng_id => session[:user_id],
                                       :approve_date_eng => Time.now}, :as => :role_update)
      elsif vp_eng?
        @purchasing.update_attributes({:approved_by_vp_eng => true, :approve_vp_eng_id => session[:user_id],
                                       :approve_date_vp_eng => Time.now}, :as => :role_update)  
      elsif pur_eng?
        @purchasing.update_attributes({:approved_by_pur_eng => true, :approve_pur_eng_id => session[:user_id],
                                       :approve_date_pur_eng => Time.now}, :as => :role_update)   
      elsif ceo?
        @purchasing.update_attributes({:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                       :approve_date_ceo => Time.now}, :as => :role_update) 
      end
    
      redirect_to project_purchasings_path(@project, @purchasing)
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!") 
    end
  end

  def dis_approve
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if need_approve?(@purchasing)
      if is_tech_eng? && @purchasing.eng_id == session[:user_id]
        @purchasing.update_attributes({:approved_by_eng => false, :approve_eng_id => session[:user_id],
                                       :approve_date_eng => Time.now}, :as => :role_update)
      elsif vp_eng?
        @purchasing.update_attributes({:approved_by_vp_eng => false, :approve_vp_eng_id => session[:user_id],
                                       :approve_date_vp_eng => Time.now}, :as => :role_update)  
      elsif pur_eng?
        @purchasing.update_attributes({:approved_by_pur_eng => false, :approve_pur_eng_id => session[:user_id],
                                       :approve_date_pur_eng => Time.now}, :as => :role_update)   
      elsif ceo?
        @purchasing.update_attributes({:approved_by_ceo => false, :approve_ceo_id => session[:user_id],
                                       :approve_date_ceo => Time.now}, :as => :role_update) 
      end
    
      redirect_to project_purchasings_path(@project, @purchasing)
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!") 
    end
  end

  def re_approve
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if ceo?
        @purchasing.update_attributes({:approved_by_eng => nil, :approve_eng_id => nil,:approve_date_eng => nil,
                                       :approved_by_vp_eng => nil, :approve_vp_eng_id => nil, :approve_date_vp_eng => nil,
                                       :approved_by_pur_eng => nil, :approve_pur_eng_id => nil, :approve_date_pur_eng => nil,
                                       :approved_by_ceo => nil, :approve_ceo_id => nil, :approve_date_ceo => nil},
                                       :as => :role_update)
    
      redirect_to project_purchasings_path(@project, @purchasing)
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!") 
    end
  end
      
  protected
  
  def need_approve?(purchasing)
    if is_tech_eng? && purchasing.eng_id == session[:user_id] && purchasing.approved_by_vp_eng.nil? && purchasing.approved_by_pur_eng.nil? && purchasing.approved_by_ceo.nil?
      return true
    elsif vp_eng? && purchasing.approved_by_eng && purchasing.approved_by_pur_eng.nil? && purchasing.approved_by_ceo.nil?
      return true
    elsif pur_eng? && purchasing.approved_by_eng && purchasing.approved_by_vp_eng && purchasing.approved_by_ceo.nil?
      return true
    elsif ceo? && purchasing.approved_by_eng && purchasing.approved_by_vp_eng && purchasing.approved_by_pur_eng 
      return true
    end
    return false
  end
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_create_right?
    mech_eng? || elec_eng? || vp_eng? || ceo? || coo?
  end
  
  def has_update_right?
    mech_eng? || elec_eng? || pur_eng? || vp_eng? || ceo? || coo?
  end
  
  def has_log_right?
    pur_eng? || vp_eng? || comp_sec? || vp_sales? || coo? || ceo?
  end

end
