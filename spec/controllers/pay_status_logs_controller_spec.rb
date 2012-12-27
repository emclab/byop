# encoding: utf-8
require 'spec_helper'

describe PayStatusLogsController do
  before(:each) do
    controller.should_receive(:require_signin)
    controller.should_receive(:require_employee)
  end
  
  render_views
  
  describe "GET 'new'" do
    it "returns http success for vp_eng" do
      session[:vp_eng] = true
      payment = FactoryGirl.create(:payment_log)
      get 'new', :payment_log_id => payment.id
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      session[:pur_eng] = true
      u = FactoryGirl.create(:user)
      payment = FactoryGirl.create(:payment_log, :input_by_id => u.id)      
      p = FactoryGirl.attributes_for(:pay_status_log, :input_by_id => u.id)
      get 'create', :pay_status_log => p, :payment_log_id => payment.id
      response.should redirect_to payment_log_path(payment)
    end
  end

end
