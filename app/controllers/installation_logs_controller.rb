# encoding: utf-8
class InstallationLogsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?

  def index
    @title= "安装计划Log"   
    @installation = Installation.find(params[:installation_id])
    @installation_logs = @installation.installation_logs
  end

      
  def new
    @title= "输入Log"   
    @installation = Installation.find(params[:installation_id])
    @installation_log = @installation.installation_logs.new()
    if !has_create_right?
      redirect_to URI.escape("/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @installation = Installation.find(params[:installation_id])
      @installation_log = @installation.installation_logs.new(params[:installation_log], :as => :role_new)
      @installation_log.input_by_id = session[:user_id]
      if @installation_log.save
        redirect_to installation_path(@installation), :notice => "Log已保存！"
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
    is_eng? || vp_eng? || comp_sec? || coo? || vp_sales? || ceo?
  end
  

end
