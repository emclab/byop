# encoding: utf-8
class ManufacturersController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee

  helper_method :has_update_right?, :has_create_right?
    
  def index
    @title = "制造商"
    @mfgs = Manufacturer.order("name")
  end

  def new
    @title = "输入制造商"    
    if has_create_right?
      @mfg = Manufacturer.new()
    else
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @mfg = Manufacturer.new(params[:manufacturer], :as => :role_new)
      @mfg.input_by_id = session[:user_id]
      if @mfg.save
        redirect_to URI.escape("/view_handler?index=0&msg=制造商已保存！")
      else
        flash.now[:error] = "无法保存！"
        render 'new'
      end
    else
       redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")     
    end
  end

  def edit
    @title = "更新制造商"    
    if has_update_right?
      @mfg = Manufacturer.find(params[:id])
    else
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end    
  end

  def update
    if has_update_right?
      @mfg = Manufacturer.find(params[:id])
      @mfg.input_by_id = session[:user_id]
      if @mfg.update_attributes(params[:manufacturer], :as => :role_update)
        #email notice
        redirect_to URI.escape("/view_handler?index=0&mfg=已更新制造商信息！")
      else
        flash.now[:error] ="无法更新制造商信息！"
        render 'edit'
      end
    else
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end        
  end
  
  protected
  
  def has_update_right?
    pur_eng? || vp_eng?
  end
  
  def has_create_right?
    pur_eng? || vp_eng?
  end


end
