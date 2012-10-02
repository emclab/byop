# encoding: utf-8
class PartsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
    
  helper_method :has_create_right?, :has_show_right?, :has_update_right?, :has_log_right?
  
  def index
    @title = '物料一览'
    if comp_sec? || vp_eng? || pur_eng? || ceo? || coo?
      @parts = Part.order("stock_qty DESC, in_date DESC").paginate(:per_page => 40, :page => params[:page])    
    else
      @parts = Part.where("stock_qty > ?", 0).order("in_date DESC").paginate(:per_page => 40, :page => params[:page])
    end
  end

  def new
    @title = '入库物料'
    @part = Part.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @part = Part.new(params[:part], :as => :role_new)
      @part.input_by_id = session[:user_id]
      @part.stock_qty = params[:part][:in_qty].to_i 
      if @part.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=入库物料已保存！")
      else
        flash.now[:error] = '数据错误，无法保存！'
        render 'new'
      end
    end
  end

  def edit
    @title = '更改已入库物料'
    @part = Part.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @part = Part.find(params[:id])
      @part.input_by_id = session[:user_id]
      if @part.update_attributes(params[:part], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=入库物料已更改！")
      else
        flash.now[:error] = '数据错误，无法保存!'
        render 'edit'
      end
    end
  end

  def show
    @title = '物料内容'
    @part = Part.find(params[:id])
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
    pur_eng? || vp_eng? || ceo?
  end
  
  def has_log_right?
    pur_eng? || vp_eng?
  end

end

