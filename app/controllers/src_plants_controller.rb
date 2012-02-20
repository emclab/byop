# encoding: utf-8
class SrcPlantsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?, :has_show_right?, :has_update_right?
    
  def index
    @title = '外协厂家'
    if src_eng? || vp_eng? || ceo? || coo?
      @src_plants = SrcPlant.order("created_at DESC, active DESC").paginate(:per_page => 40, :page => params[:page])    
    else
      @src_plants = SrcPlant.active_plant.order("created_at DESC").paginate(:per_page => 40, :page => params[:page])
    end
  end

  def new
    @title = '输入外协厂家'
    @src_plant = SrcPlant.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @src_plant = SrcPlant.new(params[:src_plant], :as => :role_new)
      @src_plant.input_by_id = session[:user_id]
      if @src_plant.save
        redirect_to URI.escape("/view_handler?index=0&msg=外协厂信息已保存！")
      else
        flash.now[:error] = '数据错误，无法保存！'
        render 'new'
      end
    end
  end

  def edit
    @title = '更改外协厂家'
    @src_plant = SrcPlant.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @src_plant = SrcPlant.find(params[:id])
      @src_plant.input_by_id = session[:user_id]
      if @src_plant.update_attributes(params[:src_plant], :as => :role_update)
        redirect_to URI.escape("/view_handler?index=0&msg=外协厂信息已更改！")
      else
        flash.now[:error] = '数据错误，无法保存!'
        render 'edit'
      end
    end
  end

  def show
    @title = '外协厂家内容'
    @src_plant = SrcPlant.find(params[:id])
    if !has_show_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end
  
  protected
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_create_right?
    src_eng? || vp_eng? || ceo?
  end
  
  def has_update_right?
    src_eng? || vp_eng? || ceo? || coo?
  end
  

end
