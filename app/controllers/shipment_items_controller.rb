#encoding: utf-8
class ShipmentItemsController < ApplicationController
  before_filter :require_employee 
  
  def index
    @shipment = Shipment.find_by_id(params[:shipment_id])
    @shipment_items = @shipment.shipment_items.order('id')
  end
  
end
