class UserMenusController < ApplicationController
  
  before_filter :require_signin
  helper_method :is_worker?
  
  def index  
    #set session vars for viewing history
    session[:page_step] = 1
    session[:page1] = user_menus_path
    render 'user_menus/index'
  end 
  
  protected
  
  def is_worker?
    qc_eng? || mech_eng? or elec_eng? or hydr_eng? or pur_eng? or inst_eng? or src_eng? or comp_sec? or acct? or warehouse? or coo? or vp_eng? or vp_sales? or ceo?
  end

end
