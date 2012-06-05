# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_signin
  before_filter :session_timeout
  
  #for methods available to the whole app
  helper_method 

  include SessionsHelper
  
  def session_timeout
    return if Rails.env.test?
    #check session last_seen
    if session[:last_seen] < SESSION_TIMEOUT_MINUTES.minutes.ago
      reset_session
    else
      session[:last_seen] = Time.now.utc
    end unless session[:last_seen].nil?
    #check when session created
    if Session.first.created_at < SESSION_WIPEOUT_HOURS.hours.ago
      Session.sweep
    end unless Session.first.nil?
  end
  
  def require_employee
    if !employee? 
      flash.now[:error] = "Access denied!"
      redirect_to root_path
    end
  end
    
  def require_admin
    admin?
  end
  
  def require_signin
    if !signed_in?  
      flash.now.alert = "必须登录!"
      redirect_to signin_path
    end
  end   

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  #handle the viewing history. :url and :index passed in from the link as params.
  # :index =0 means backword, :index=1 means forward. When forwarding, url is the url to save for back.
  def view_handler
    index  = params[:index].to_i
    url = params[:url]
    msg = params[:msg]
    if index == 0   #backword
      session[:page_step] -= 1  #step_back
      url = session[('page' + session[:page_step].to_s).to_sym]      
    else  #forward
      session[:page_step] += 1 
      session[('page' + session[:page_step].to_s).to_sym] = url
    end

    #redirect to the page by url  
    if msg.nil?                                                         
      redirect_to url
    else
      redirect_to url, :notice => msg
    end   
  end

  #simple logging for a user
  def sys_logger(action_logged)
    log = SysLog.new({:log_date => Time.now, :user_id => session[:user_id], :user_name => session[:user_name], :user_ip => session[:user_ip],
                     :action_logged => action_logged}, :as => :new_log)
    log.save!
  end
  
end
