# encoding: utf-8
class InstallationPurchaseLogsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?
    
  def new
    @title= "输入Log"   
    @installation_purchase = InstallationPurchase.find(params[:installation_purchase_id])
    @installation_purchase_log = @installation_purchase.installation_purchase_logs.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @installation_purchase = InstallationPurchase.find(params[:installation_purchase_id])
      @installation_purchase_log = @installation_purchase.installation_purchase_logs.new(params[:installation_purchase_log], :as => :role_new)
      @installation_purchase_log.input_by_id = session[:user_id]
      if @installation_purchase_log.save
        redirect_to installation_installation_purchase_path(@installation_purchase.installation, @installation_purchase), :notice => "Log已保存！"
      else
        flash.now[:error] = "无法保存Log！"
        render 'new'
      end     
    else
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")    
    end
  end

  protected
  
  def has_create_right?
    inst_eng? || vp_eng? || coo? || ceo?
  end
  
end
