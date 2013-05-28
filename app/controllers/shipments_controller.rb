# encoding: utf-8
class ShipmentsController < ApplicationController
  before_filter :require_employee 
  before_filter :load_project 
  
  helper_method :has_show_right?, :has_create_right?, :has_approve_right?, :has_update_right?, :display_approve?, :display_dis_approve?
  
  def index
    @title= "发货运输" 
    if @project
      @shipments = @project.shipments.order('cancelled, shipping_date DESC').paginate(:per_page => 40, :page => params[:page])
    else
      @shipments = Shipment.where('shipping_date > ?', 2.years.ago).order('cancelled, shipping_date DESC').paginate(:per_page => 40, :page => params[:page])
    end
  end

  def new
    @title= "输入发货运输" 
    if has_create_right?
      @shipment = @project.shipments.new()
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @shipment = @project.shipments.new(params[:shipment], :as => :role_new)
      @shipment.input_by_id = session[:user_id]
      if @shipment.save
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=发货运输已保存！")
      else
        flash.now[:error] = "数据错误。无法保存"
        render 'new'
      end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def edit
    @title= "更改发货运输" 
    if has_update_right?
      @shipment = Shipment.find_by_id(params[:id])
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @shipment = Shipment.find_by_id(params[:id])
      @shipment.input_by_id = session[:user_id]
      if @shipment.update_attributes(params[:shipment], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=发货运输已更改！")
      else
        flash.now[:error] = "数据错误。无法更改"
        render 'edit'
      end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def show
    @title= "发货运输内容" 
    if has_show_right?
      @shipment = Shipment.find_by_id(params[:id])
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end
  
  def approve
    
    @shipment = @project.shipments.find(params[:id])
    #if need_approve?(@shipment)  
    if ceo?
        @shipment.update_attributes({:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                    :approve_date_ceo => Time.now}, :as => :role_approve) 
    
      redirect_to project_shipment_path(@project, @shipment), :notice => '货运已批准！'
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!")    
    end
  end

  def dis_approve
    
    @shipment = @project.shipments.find(params[:id])
    #if need_approve?(@shipment)  
    if ceo?
        @shipment.update_attributes({:approved_by_ceo => false, :approve_ceo_id => session[:user_id],
                                    :approve_date_ceo => Time.now}, :as => :role_approve) 
      #end
    
      redirect_to project_shipment_path(@project, @shipment), :notice => '货运已否决！'
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足!")    
    end
  end
  
  protected
  
  def display_approve?(shipment)
    if ceo? && (shipment.approved_by_ceo.nil? || !shipment.approved_by_ceo)
      return true
    end
    return false
  end
  
  def display_dis_approve?(shipment)
    if ceo? && (shipment.approved_by_ceo.nil? || shipment.approved_by_ceo)
      return true
    end
    return false
  end 
  
  def has_show_right?
    pur_eng? || src_eng? || vp_eng? || ceo?
  end
  
  def has_create_right?
    pur_eng? || src_eng?
  end
  
  def has_update_right?
    pur_eng? || src_eng?
  end
  
  def has_approve_right?
    ceo?
  end
  
  def load_project
    @project = Project.find_by_id(params[:project_id]) if params[:project_id].present?
  end
end
