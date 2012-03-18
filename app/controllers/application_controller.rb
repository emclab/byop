# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :require_signin
  
  #for methods available to the whole app
  helper_method 

  include SessionsHelper
  
  def session_sweep
   Session.sweep()  
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
  
end
