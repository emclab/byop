# encoding: utf-8
class OutLogsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee  
  
  helper_method :has_create_right?
  
  def new
    @title= "出库记录"   
    @part = Part.find(params[:part_id])
    @out_log = @part.out_logs.new()
    if !has_create_right?
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end

  def create
    if has_create_right?
      @part = Part.find(params[:part_id])
      @out_log = @part.out_logs.new(params[:out_log], :as => :role_new)
      @out_log.input_by_id = session[:user_id]
      @part.stock_qty = @part.stock_qty - params[:out_log][:out_qty].to_i      
      #start transaction
      @out_log.transaction do
        if @out_log.save && @part.save
          redirect_to part_path(@part), :notice => "记录已保存！"
        else
          flash.now[:error] = "无法保存出库记录！"
          render 'new'
        end   
      end  
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")    
    end
  end

  def show
    @part = Part.find(params[:part_id])
    @out_log = OutLog.find(params[:id])
  end

  protected
  
  def has_create_right?
    pur_eng? || vp_eng? || ceo?
  end
  
end
