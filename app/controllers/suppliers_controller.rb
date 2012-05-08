# encoding: utf-8
class SuppliersController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?
    
  def index
    @title = '供应商'
    if pur_eng? || vp_eng? || ceo? || coo?
      @suppliers = Supplier.order("created_at DESC, active DESC").paginate(:per_page => 40, :page => params[:page])    
    else
      @suppliers = Supplier.active_supplier.order("created_at DESC").paginate(:per_page => 40, :page => params[:page])
    end    
  end

  def new
    @title = '输入供应商'
    @supplier = Supplier.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end    
  end

  def create
    if has_create_right?
      @supplier = Supplier.new(params[:supplier], :as => :role_new)
      @supplier.input_by_id = session[:user_id]
      if @supplier.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=供应商信息已保存！")
      else
        flash.now[:error] = '数据错误，无法保存！'
        render 'new'
      end
    end    
  end

  def edit
    @title = '更改供应商'
    @supplier = Supplier.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end    
  end

  def update
    if has_update_right?
      @supplier = Supplier.find(params[:id])
      @supplier.input_by_id = session[:user_id]
      if @supplier.update_attributes(params[:supplier], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=供应商信息已更改！")
      else
        flash.now[:error] = '数据错误，无法保存!'
        render 'edit'
      end
    end    
  end

  def show
    @title = '供应商内容'
    @supplier = Supplier.find(params[:id])
    if !has_show_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end    
  end

  protected
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_create_right?
    pur_eng? || vp_eng? || ceo?
  end
  
  def has_update_right?
    pur_eng? || vp_eng? || ceo? || coo?
  end
  
  
end
