# encoding: utf-8
class SysLogsController < ApplicationController
  before_filter :require_signin
  before_filter :require_employee
  
  helper_method :has_view_right?
  
  def index
    if has_view_right?
      @sys_logs = SysLog.order("id DESC").paginate(:per_page => 50, :page => params[:page])
    else
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=权限不足！")
    end
  end
  
  def sort_by_user_id
    if has_view_right?
      @sys_logs = SysLog.order("user_id").paginate(:per_page => 50, :page => params[:page])
      redirect_to URI.escape(SUBURI + "/view_handler?index=1&url=#{sys_logs_path}")
    end
  end
  
  def sort_by_ip
    if has_view_right?
      @sys_logs = SysLog.order("user_ip").paginate(:per_page => 50, :page => params[:page])
      redirect_to URI.escape(SUBURI + "/view_handler?index=1&url=#{sys_logs_path}")
    end    
  end
  
  private
  
  def has_view_right?
    return true if admin? || comp_sec? || coo? || ceo?
  end
  
end
