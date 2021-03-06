# encoding: utf-8
class PurchasingsController < ApplicationController
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_log_right?, :has_stats_right?, :has_delete_right?, :has_reorder_right?,
                :need_approve?, :approved?, :display_approve?, :display_dis_approve?
                
  def index
    @title = '外购计划'
    @project = Project.find(params[:project_id])
    @purchasings = @project.purchasings.order("delivered, created_at DESC, order_date, delivery_date").paginate(:per_page => 40, :page => params[:page])    
  end

  def new
    @title = '输入外购'
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
    @title = '更改外购'
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
  
  def destroy
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if !has_delete_right? 
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    else    
      if !approved?(@purchasing) 
        @purchasing.transaction do
          #delete purchasing log
          @purchasing.purchasing_logs.each do |r|
            r.destroy
          end
          #delete payment log
          @purchasing.payment_logs.each do |r|
            r.destroy
          end
          @purchasing.destroy
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=计划已删除！")
        end
      end
    end
  end
  
  def approve
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if need_approve?(@purchasing)
      if is_tech_eng? && @purchasing.eng_id == session[:user_id]
        if @purchasing.update_attributes({:approved_by_eng => true, :approve_eng_id => session[:user_id],
                                       :approve_date_eng => Time.now}, :as => :role_approve_disapprove_stamped)
          redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购已批准！'
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=数据错误。外购未批准!")
        end
      elsif vp_eng?
        if @purchasing.update_attributes({:approved_by_vp_eng => true, :approve_vp_eng_id => session[:user_id],
                                       :approve_date_vp_eng => Time.now}, :as => :role_approve_disapprove_stamped)  
          redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购已批准！'
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=数据错误。外购未批准!")
        end                         
      elsif pur_eng?
        if @purchasing.update_attributes({:approved_by_pur_eng => true, :approve_pur_eng_id => session[:user_id],
                                       :approve_date_pur_eng => Time.now}, :as => :role_approve_disapprove_stamped) 
          redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购已批准！'
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=数据错误。外购未批准!")
        end                               
      elsif ceo?
        if @purchasing.update_attributes({:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                       :approve_date_ceo => Time.now}, :as => :role_approve_disapprove_stamped) 
          redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购已批准！'
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=数据错误。外购未批准!")
        end                             
      end     
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!") 
    end
  end

  def dis_approve
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if need_approve?(@purchasing)
      if is_tech_eng? && @purchasing.eng_id == session[:user_id]
        if @purchasing.update_attributes({:approved_by_eng => false, :approve_eng_id => session[:user_id],
                                       :approve_date_eng => Time.now}, :as => :role_approve_disapprove_stamped)
          redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购已否决！' 
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=数据错误。外购未否决!")
        end
      elsif vp_eng?
        if @purchasing.update_attributes({:approved_by_vp_eng => false, :approve_vp_eng_id => session[:user_id],
                                       :approve_date_vp_eng => Time.now}, :as => :role_approve_disapprove_stamped)  
          redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购已否决！' 
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=数据错误。外购未否决!")
        end                
      elsif pur_eng?
        if @purchasing.update_attributes({:approved_by_pur_eng => false, :approve_pur_eng_id => session[:user_id],
                                       :approve_date_pur_eng => Time.now}, :as => :role_approve_disapprove_stamped) 
           redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购已否决！' 
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=数据错误。外购未否决!")
        end                     
      elsif ceo?
        if @purchasing.update_attributes({:approved_by_ceo => false, :approve_ceo_id => session[:user_id],
                                       :approve_date_ceo => Time.now}, :as => :role_approve_disapprove_stamped)
          redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购已否决！' 
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=数据错误。外购未否决!")
        end                     
      end       
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!") 
    end
  end

  #re-start the whole process again
  def re_approve
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if ceo?
        @purchasing.update_attributes({:approved_by_eng => nil, :approve_eng_id => nil,:approve_date_eng => nil,
                                       :approved_by_vp_eng => nil, :approve_vp_eng_id => nil, :approve_date_vp_eng => nil,
                                       :approved_by_pur_eng => nil, :approve_pur_eng_id => nil, :approve_date_pur_eng => nil,
                                       :approved_by_ceo => nil, :approve_ceo_id => nil, :approve_date_ceo => nil},
                                       :as => :role_approve_disapprove_stamped)
    
      redirect_to project_purchasing_path(@project, @purchasing), :notice => '外购需要重新批准！'
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!") 
    end
  end
  
  def stamp
    @project = Project.find(params[:project_id])
    @purchasing = @project.purchasings.find(params[:id])
    if comp_sec?
      @purchasing.update_attributes({:stamped => true}, :as => :role_approve_disapprove_stamped)
      redirect_to project_purchasing_path(@project, @purchasing)
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!")       
    end    
  end
  
  def search
    @purchasing = Purchasing.new
  end

  def search_results
    @purchasing = Purchasing.new(params[:purchasing], :as => :role_search_stats)
    @purchasings = @purchasing.find_purchasings.order("project_id DESC, delivered, created_at DESC, order_date, delivery_date") #.paginate(:per_page => 40, :page => params[:page])
    #seach params
    @search_params = search_params()
  end
        
  protected
  
  def need_approve?(purchasing)
    if is_tech_eng? && purchasing.eng_id == session[:user_id] && purchasing.approved_by_pur_eng.nil? && purchasing.approved_by_ceo.nil?  && purchasing.approved_by_vp_eng.nil? 
      return true
    elsif pur_eng? && purchasing.approved_by_eng  && purchasing.approved_by_ceo.nil? && purchasing.approved_by_vp_eng.nil?
      return true
    elsif vp_eng? && purchasing.approved_by_eng && purchasing.approved_by_pur_eng && purchasing.approved_by_ceo.nil?
      return true
    elsif ceo? && purchasing.approved_by_eng  && purchasing.approved_by_pur_eng && purchasing.approved_by_vp_eng
      return true
    end
    return false
  end
 
  def display_approve?(purchasing)
    if is_tech_eng? && purchasing.eng_id == session[:user_id] && (purchasing.approved_by_eng.nil? || !purchasing.approved_by_eng)
      return true
    elsif vp_eng? && (purchasing.approved_by_vp_eng.nil? || !purchasing.approved_by_vp_eng)
      return true
    elsif pur_eng? && (purchasing.approved_by_pur_eng.nil? || !purchasing.approved_by_pur_eng)
      return true
    elsif ceo? && (purchasing.approved_by_ceo.nil? || !purchasing.approved_by_ceo)
      return true
    end
    return false
  end
  
  def display_dis_approve?(purchasing)
    if is_tech_eng? && purchasing.eng_id == session[:user_id] && (purchasing.approved_by_eng.nil? || purchasing.approved_by_eng)
      return true
    elsif vp_eng? && (purchasing.approved_by_vp_eng.nil? || purchasing.approved_by_vp_eng)
      return true
    elsif pur_eng? && (purchasing.approved_by_pur_eng.nil? || purchasing.approved_by_pur_eng)
      return true
    elsif ceo? && (purchasing.approved_by_ceo.nil? || purchasing.approved_by_ceo)
      return true
    end
    return false
  end
  
  def approved?(pur)
    return false if pur.approved_by_eng.nil? || pur.approved_by_pur_eng.nil? || pur.approved_by_ceo.nil? || pur.approved_by_vp_eng.nil? 
    return true if pur.approved_by_eng == true && pur.approved_by_pur_eng == true && pur.approved_by_ceo == true  && pur.approved_by_vp_eng == true
    return false
  end
  
  def has_reorder_right?
    pur_eng? || ceo?  || vp_eng?  
  end
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_sales? || coo? || ceo?  || vp_eng? 
  end
  
  def has_create_right?
    mech_eng? || elec_eng? || ceo? || coo?  || vp_eng? 
  end
  
  def has_update_right?
    mech_eng? || elec_eng? || pur_eng? ||  ceo? || coo?  || vp_eng? 
  end
  
  def has_log_right?
    pur_eng? ||  comp_sec? || vp_sales? || coo? || ceo?  || vp_eng? 
  end
  
  def has_stats_right?  #show stats on search page
    pur_eng? ||  vp_sales? || coo? || ceo? || vp_eng? 
  end
  
  def has_delete_right?
     ceo?  || vp_eng? 
  end
    
  def search_params
    search_params = "参数："
    search_params += ' 开始日期：' + params[:purchasing][:start_date_search] if params[:purchasing][:start_date_search].present?
    search_params += ', 结束日期：' + params[:purchasing][:end_date_search] if params[:purchasing][:end_date_search].present?
    search_params += ', 外购件名：' + params[:purchasing][:keyword_prod_name_s] if params[:purchasing][:keyword_prod_name_s].present?
    search_params += ', 客户 ：' + Customer.find_by_id(params[:purchasing][:customer_id_search].to_i).short_name if params[:purchasing][:customer_id_search].present? 
    search_params += ', 项目 ：' + Project.find_by_id(params[:purchasing][:project_id_search].to_i).name if params[:purchasing][:project_id_search].present?   
    search_params += ', 工程师：' + User.find_by_id(params[:purchasing][:eng_id_search].to_i).name if params[:purchasing][:eng_id_search].present?
    search_params += ', 制造商：' + Manufacturer.find_by_id(params[:purchasing][:mfg_id_search].to_i).name if params[:purchasing][:mfg_id_search].present?
    search_params += ', 供应商：' + Supplier.find_by_id(params[:purchasing][:supplier_id_search].to_i).name if params[:purchasing][:supplier_id_search].present?
    search_params += ', 交货了？ ：' + params[:purchasing][:delivered_search] if params[:purchasing][:delivered_search].present?
    search_params += ', 工程师批了？ ：' + params[:purchasing][:approved_by_eng_search] if params[:purchasing][:approved_by_eng_search].present?
    search_params += ', 副总批了？ ：' + params[:purchasing][:approved_by_vp_eng_search] if params[:purchasing][:approved_by_vp_eng_search].present?
    search_params += ', 采购批了？ ：' + params[:purchasing][:approved_by_pur_eng_search] if params[:purchasing][:approved_by_pur_eng_search].present?
    search_params += ', 厂长批了？ ：' + params[:purchasing][:approved_by_ceo_search] if params[:purchasing][:approved_by_ceo_search].present?
    search_params
  end
  
end
