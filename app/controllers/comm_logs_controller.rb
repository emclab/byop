# encoding: utf-8
class CommLogsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_destroy_right?
      
  def new
    @title= "输入客户联系Log"   
    @customer = Customer.find(params[:customer_id])
    @comm_log = @customer.comm_logs.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @customer = Customer.find(params[:customer_id])
      @comm_log = @customer.comm_logs.new(params[:comm_log], :as => :role_new)
      @comm_log.input_by_id = session[:user_id]
      if @comm_log.save
        redirect_to customer_path(@customer), :notice => "Log已保存！"
      else
        flash.now[:error] = "无法保存Log！"
        render 'new'
      end     
    else
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")    
    end
  end

  def show
    @title= "客户联系Log内容"
    if has_show_right?
      @customer = Customer.find(params[:customer_id])
      @comm_log = @customer.comm_logs.find(params[:id])
    else
      flash.now[:error] = "权限不足！"
    end
  end

  def destroy
    if has_destroy_right?
      @customer = Customer.find(params[:customer_id])
      @comm_log = @customer.comm_logs.find(params[:id])
      @comm_log.destroy
      respond_to do |format|
        format.html {redirect_to customer_path(@customer), :notice => "log已删除!" }
        format.js
      end
    else
      flash.now[:error] = "权限不足！"
    end
  end

  protected
  
  def has_create_right?
    comp_sec? || coo? || vp_sales? || ceo?
  end
  
  def has_destroy_right?
    comp_sec? || coo? || vp_sales? || ceo?
  end
  
  def has_show_right?
     comp_sec? || coo? || vp_sales? || ceo?
  end
  
end
