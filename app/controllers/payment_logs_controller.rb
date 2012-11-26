# encoding: utf-8
class PaymentLogsController < ApplicationController
  before_filter :require_employee  
  before_filter :load_sourcing
  before_filter :load_purchasing
  
  helper_method :has_index_right?, :has_create_right?, :has_update_right?, :has_stats_right?, :has_approve_right?, :has_paid_right?
    
  def index
    if has_index_right?
      @payment_logs =
        if @sourcing
          @sourcing.payment_logs.where("pay_date > ? AND amount > ?", 900.days.ago, 0.00).paginate(:per_page => 40, :page => params[:page]).order("pay_date DESC")
        elsif @purchasing
          @purchasing.payment_logs.where("pay_date > ? AND amount > ?", 900.days.ago, 0.00).paginate(:per_page => 40, :page => params[:page]).order("pay_date DESC")
        else
          PaymentLog.where("pay_date > ? AND amount > ?", 900.days.ago, 0.00).paginate(:per_page => 40, :page => params[:page]).order("pay_date DESC, purchasing_id DESC, sourcing_id DESC")
        end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！") 
    end
  end

  def new
    @payment_log = PaymentLog.new
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    @payment_log = PaymentLog.new(params[:payment_log], :as => :role_new_update)
    if has_create_right?
      @payment_log.input_by_id = session[:user_id]
      if @purchasing
        @payment_log.purchasing_id = @purchasing.id
      elsif @sourcing
        @payment_log.sourcing_id = @sourcing.id
      end
      if @payment_log.save
        redirect_to purchasing_payment_logs_path(@purchasing), :notice =>'记录已保存！' if @purchasing.present?
        redirect_to sourcing_payment_logs_path(@sourcing), :notice =>'记录已保存！' if @sourcing.present?
      end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def edit
    if has_update_right?
      @payment_log = PaymentLog.find(params[:id])
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @payment_log = PaymentLog.find(params[:id])
      @payment_log.input_by_id = session[:user_id]
      if @payment_log.update_attributes(params[:payment_log], :as => :role_new_update)
        redirect_to purchasing_payment_logs_path(@purchasing), :notice =>'记录已更改！' if @purchasing.present?
        redirect_to sourcing_payment_logs_path(@sourcing), :notice =>'记录已更改！' if @sourcing.present?        
      end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end
  
  def show
    if has_index_right?
      @payment_log = PaymentLog.find(params[:id])
      if @payment_log.sourcing_id.present?
        @project = Sourcing.find_by_id(@payment_log.sourcing_id).project
      else
        @project = Purchasing.find_by_id(@payment_log.purchasing_id).project
      end
    end
  end

  def approve
    @payment_log = PaymentLog.find(params[:id])
    if has_approve_right?
      if ceo?
        @payment_log.approved_by_ceo = true
        @payment_log.approve_ceo_id = session[:user_id]
        @payment_log.approve_date_ceo = Date.current
        if @payment_log.save
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=记录已批准！")
        else
          redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=记录批准未保存！")
        end
      end
    end
  end
  
  def stamp_paid
    @payment_log = PaymentLog.find(params[:id])
    if has_paid_right?
      @payment_log.paid = true
      @payment_log.paid_by_id = session[:user_id]
      @payment_log.paid_date = Date.current
      if @payment_log.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=记录已付清！")
      else
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=记录付清未保存！")
      end
    end
  end

  def search
    @payment_log = PaymentLog.new
  end

  def search_results
    @payment_log = PaymentLog.new(params[:payment_log], :as => :role_search_stats)
    @payment_logs = @payment_log.find_payment_logs  #.order("project_id DESC, delivered, created_at DESC, order_date, delivery_date") #.paginate(:per_page => 40, :page => params[:page])
    #seach params
    @search_params = search_params()
  end
    
  def stats
    if has_stats_right?
      @payment_log = PaymentLog.new
    end
  end
  
  def stats_results
    if has_stats_right?
      @payment_log = PaymentLog.new(params[:payment_log], :as => :role_search_stats)
      @payment_log_stats = @payment_log.find_payment_logs
      #retrieve parameter
      @stats_params = "参数： 分类：" + params[:payment_log][:for_search] + '，统计条数：' + @payment_log_stats.count.to_s 
      group_records(params[:payment_log][:for_search]) #result in record_stats & @stats_params
      @stats_params += ', 项目：' + Project.find_by_id(params[:payment_log][:project_id_search]).name if params[:payment_log][:project_id_search].present?
      @stats_params += ' 开始日期：' + params[:payment_log][:start_date_search] if params[:payment_log][:start_date_search].present?
      @stats_params += ', 厂长批准：' + params[:payment_log][:approved_by_ceo_s] if params[:payment_log][:approved_by_ceo_s].present?
      @stats_params += ' 已支付：' + params[:payment_log][:paid_s] if params[:payment_log][:paid_s].present?
      @stats_params += ', 供应商：' + Supplier.find(params[:payment_log][:supplier_id_search]).name if params[:payment_log][:supplier_id_search].present?
      @stats_params += ', 外协厂：' + SrcPlant.find(params[:payment_log][:src_plant_id_search]).name if params[:payment_log][:src_plant_id_search].present?
      return if @payment_log_stats.blank?  #empty record causes error in following code   
      add_summary_to_stats_params()   
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=无统计权限！")      
    end      
  
  end
  
  protected

  def group_records(for_search)
      case for_search #params
      when '外购'
        @payment_log_stats = @payment_log_stats.where("purchasing_id IS NOT NULL").all(:select => "max(pay_date) as last_pay_date, sum(amount) as total_payment, count(DISTINCT(payment_logs.id)) as num_payment, 
                                purchasing_id, sourcing_id", :group => "purchasing_id")
                          
      when '外协'
        @payment_log_stats = @payment_log_stats.where("sourcing_id IS NOT NULL").all(:select => "max(pay_date) as last_pay_date, sum(amount) as total_payment, count(DISTINCT(payment_logs.id)) as num_payment, 
                                purchasing_id, sourcing_id", :group => "sourcing_id")
      else 
        @payment_log_stats = @payment_log_stats.all(:select => "max(pay_date) as last_pay_date, sum(amount) as total_payment, count(DISTINCT(payment_logs.id)) as num_payment, 
                                purchasing_id, sourcing_id", :group => "purchasing_id, sourcing_id")                            
      end   
  end
  
  def add_summary_to_stats_params
    cost_total, pay_total, total_num_payment = 0.00, 0.00, 0.00
    @payment_log_stats.each do |p|
      cost_total += p.sourcing.total if p.sourcing_id.present? && p.sourcing.total.present?
      cost_total += p.purchasing.total if p.purchasing_id.present? && p.purchasing.total.present?
      pay_total += p.total_payment
      total_num_payment += p.num_payment
    end
    d_total = pay_total - cost_total if pay_total.present? && cost_total.present?
    d_total = pay_total if pay_total.present? && cost_total.nil?
    @stats_params += "\n" + ", 应付总额: ￥" + cost_total.to_s + ", 已付总额: ￥" + pay_total.to_s + ", 总差额: ￥" + d_total.to_s + ", 付款总次数: " + total_num_payment.to_s
  end

  def search_params
    search_params = "参数："
    search_params += ' 开始日期：' + params[:payment_log][:start_date_search] if params[:payment_log][:start_date_search].present?
    search_params += ', 结束日期：' + params[:payment_log][:end_date_search] if params[:payment_log][:end_date_search].present?
    search_params += ', 分类：' + params[:payment_log][:for_search] if params[:payment_log][:for_search].present?
    search_params += ', 项目 ：' + Project.find_by_id(params[:payment_log][:project_id_search].to_i).name if params[:payment_log][:project_id_search].present?   
    search_params += ', 外协厂：' + SrcPlant.find_by_id(params[:payment_log][:src_plant_id_search].to_i).name if params[:payment_log][:src_plant_id_search].present?
    search_params += ', 供应商：' + Supplier.find_by_id(params[:payment_log][:supplier_id_search].to_i).name if params[:payment_log][:supplier_id_search].present?
    search_params += ', 厂长批准 ：' + params[:payment_log][:approved_by_ceo_s] if params[:payment_log][:approved_by_ceo_s].present?
    search_params += ', 已支付 ：' + params[:payment_log][:paid_s] if params[:payment_log][:paid_s].present?    
    search_params
  end
      
  def has_approve_right?
    ceo? || acct?
  end
  
  def has_paid_right?
    acct?  
  end
  
  def has_index_right?
    acct? || comp_sec? || pur_eng? || src_eng? || coo? || vp_eng? || vp_sales? || ceo?
  end
  
  def has_create_right?
    acct? || comp_sec? || pur_eng? || src_eng? || coo? || vp_eng? || vp_sales? || ceo?
  end
  
  def has_update_right?
    acct? || comp_sec? || pur_eng? || src_eng? || coo? || vp_eng? || vp_sales? || ceo?
  end
  
  def has_stats_right?
    acct? || comp_sec? || pur_eng? || src_eng? || coo? || vp_eng? || vp_sales? || ceo?
  end
  
  def load_sourcing
    @sourcing = Sourcing.find(params[:sourcing_id]) if params[:sourcing_id].present?
  end

  def load_purchasing
    @purchasing = Purchasing.find(params[:purchasing_id]) if params[:purchasing_id].present?
  end
end
