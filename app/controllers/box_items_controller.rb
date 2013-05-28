# encoding: utf-8
class BoxItemsController < ApplicationController
  before_filter :require_employee 
  before_filter :load_shipment_item 
  
  helper_method :has_create_right?, :has_update_right?, :has_destroy_right?
  
  def index
    @box_items = @shipment_item.box_items.order('name')
  end

  def new
    if has_create_right?
      @box_item = @shipment_item.box_items.new()
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @box_item = @shipment_item.box_items.new(params[:box_item], :as => :role_new)
      @box_item.input_by_id = session[:user_id]
      if @box_item.save
        redirect_to shipment_item_box_items_path(@shipment_item), :notice => "装箱产品已保存！"
      else
        flash.now[:error] = "数据错误。无法保存"
        render 'new'
      end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def edit
    if has_update_right?
      @box_item = BoxItem.find_by_id(params[:id])
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @box_item = BoxItem.find_by_id(params[:id])
      @box_item.input_by_id = session[:user_id]
      if @box_item.update_attributes(params[:box_item], :as => :role_update)
        redirect_to shipment_item_box_items_path(@shipment_item), :notice => "装箱产品已更改！"
      else
        flash.now[:error] = "数据错误。无法更改"
        render 'edit'
      end
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def destroy
    if has_destroy_right?
      @box_item = BoxItem.find_by_id(params[:id])
      @box_item.destroy
      redirect_to shipment_item_box_items_path(@shipment_item), :notice => "装箱产品已删除！"
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end
  
  protected
  def load_shipment_item
    @shipment_item = ShipmentItem.find_by_id(params[:shipment_item_id]) if params[:shipment_item_id].present?
  end
  
  def has_create_right?
    pur_eng? || src_eng? 
  end
  
  def has_update_right?
    pur_eng? || src_eng?
  end
  
  def has_destroy_right?
    pur_eng? || src_eng?
  end
end
