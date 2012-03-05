# encoding: utf-8
class InstallationPurchasesController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  before_filter :load_installation
    
  helper_method :has_show_right?, :has_create_right?, :has_update_right?, :has_log_right?, :need_approve?
  
  def index
    @title = '安装物料'
    @installation_purchases = @installation.present? ? @installation.installation_purchases.order("need_date DESC, qty_in_stock DESC, id DESC").paginate(:per_page => 40, :page => params[:page]) : Installation_purchase.where('created_date > ?', Time.now - 1000.day).order("need_date DESC, qty_in_stock DESC, id DESC").paginate(:per_page => 40, :page => params[:page])        
  end

  def new
    @title = '物料申请'
    @installation = Installation.find(params[:installation_id])
    @installation_purchase = @installation.installation_purchases.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @installation = Installation.find(params[:installation_id])
      @installation_purchase = @installation.installation_purchases.new(params[:installation_purchase], :as => :role_new)
      @installation_purchase.input_by_id = session[:user_id]
      if @installation_purchase.save
        redirect_to URI.escape("/view_handler?index=0&msg=申请已保存！")
      else
        flash.now[:error] = '数据错误，无法保存！'
        render 'new'
      end
    end
  end

  def edit
    @title = '修改物料申请'
    @installation = Installation.find(params[:installation_id])
    @installation_purchase = @installation.installation_purchases.find(params[:id])
    if !has_update_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def update
    if has_update_right?
      @installation = Installation.find(params[:installation_id])
      @installation_purchase = @installation.installation_purchases.find(params[:id])
      @installation_purchase.input_by_id = session[:user_id]
      if @installation_purchase.update_attributes(params[:installation_purchase], :as => :role_update)
        redirect_to URI.escape("/view_handler?index=0&msg=申请已更改！")
      else
        flash.now[:error] = '数据错误，无法保存!'
        render 'edit'
      end
    end
  end

  def show
    @title = '物料申请内容'
    @installation = Installation.find(params[:installation_id])
    @installation_purchase = @installation.installation_purchases.find(params[:id]) 
    if !has_show_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")           
    end
  end

  def approve    
    @installation = Installation.find(params[:installation_id])
    @installation_purchase = @installation.installation_purchases.find(params[:id])
    if need_approve?(@installation_purchase)  
      if vp_eng?
        @installation_purchase.update_attributes(:approved_by_vp_eng => true, :approve_vp_eng_id => session[:user_id],
                                    :approve_date_vp_eng => Date.today, :as => :role_update) 
     
      elsif ceo?
        @installation_purchase.update_attributes(:approved_by_ceo => true, :approve_ceo_id => session[:user_id],
                                    :approve_date_ceo => Time.now, :as => :role_update) 
      end   
      redirect_to installation_installation_purchase_path(@installation, @installation_purchase)
    else
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足!")    
    end
  end
    
  protected

  def need_approve?(inst_pur)
    if vp_eng? && !inst_pur.approved_by_ceo
      return true
    elsif ceo? && inst_pur.approved_by_vp_eng 
      return true
    end
    return false
  end  
  
  def has_show_right?
    is_eng? || acct? || comp_sec? || vp_eng? || vp_sales? || coo? || ceo?
  end
  
  def has_create_right?
    inst_eng? || vp_eng?
  end
  
  def has_update_right?
    vp_eng? || ceo?
  end
  
  def has_log_right?
    inst_eng? || vp_eng? || comp_sec? || coo? || ceo?
  end
    
  def load_installation
    @installation = Installation.find(params[:installation_id]) if params[:installation_id].present?
  end  

end
