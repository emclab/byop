#encoding: utf-8
require 'spec_helper'

describe ShipmentItemsController do
  before(:each) do
    #the following recognizes that there is a before filter without execution of it.
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
    
  render_views  
  describe "GET 'index'" do
    before(:each) do
      cust = FactoryGirl.create(:customer)
      @proj = FactoryGirl.create(:project, :customer_id => cust.id)
      @si = FactoryGirl.build(:shipment_item)
      @sh = FactoryGirl.create(:shipment, :project_id => @proj.id, :shipping_date => Time.now, :shipment_items => [@si])
     
    end
    it "returns http success" do
      get 'index', :shipment_id => @sh.id
      assigns(:shipment_items) =~ [@si]
    end
  end

end
