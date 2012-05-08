# encoding: utf-8
class CustomersController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_update_right?, :has_show_right?, :has_log_right?, :return_last_contact_date
    
  def index
    @title = '客户一览'
    if comp_sec? || coo? || ceo? || vp_sales?
      @customers = Customer.order("id DESC").paginate(:per_page => 30, :page => params[:page])
    else
      @customers = Customer.active_cust.order("id DESC").paginate(:per_page => 30, :page => params[:page])
    end
  end  

  def new
   @title = '输入客户'
   @customer = Customer.new
   if !has_create_right?
     redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
   end      
  end

  def create
    if has_create_right?
      @customer = Customer.new(params[:customer], :as => :role_new)
      @customer.input_by_id = session[:user_id]
      if @customer.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=已保存!")        
      else
        flash[:notice] = '无法保存!'
        render 'new'
      end      
    end
  end

  def edit
   @title = '更新客户'  
   @customer = Customer.find(params[:id])    
   if !has_update_right?
     redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")  
   end
  end

  def update
    if has_update_right?
      @customer = Customer.find(params[:id])
      @customer.input_by_id = session[:user_id]
      if @customer.update_attributes(params[:customer], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=更改已保存！")
      else
        flash[:notice] = '无法保存！'
        render 'edit'
      end      
    end
  end

  def show
    @title = '客户内容'
    @customer = Customer.find(params[:id])
    if !has_show_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end
  
  protected
  
  def has_create_right?
    comp_sec? || ceo? || coo? || vp_sales?
  end
  
  def has_update_right?
    comp_sec? || ceo? || coo? || vp_sales?    
  end

  def has_show_right?
    mech_eng? || elec_eng? || hydr_eng? || pur_eng? || src_eng? || inst_eng? || acct? || vp_eng? || comp_sec? || ceo? || coo? || vp_sales?
  end
  
  def has_log_right?
    comp_sec? || ceo? || coo? || vp_sales?      
  end
  
  def return_last_contact_date(customer_id)
    log = CommLog.where("customer_id = ?", customer_id).last
    return log.created_at unless log.nil?
  end
  
end
