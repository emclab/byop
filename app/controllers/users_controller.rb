# encoding: utf-8
class UsersController < ApplicationController
  
  before_filter :require_signin
  before_filter :require_admin
  before_filter :require_employee 
   
  
  helper_method :return_user_positions
    
  def index
    @title = "用户名单"
    @users = User.order("id DESC, status ASC").paginate(:per_page => 40, :page => params[:page])
  end

  def show
    @title = "用户内容"
    @user = User.find(params[:id])
  end

  def new
    @title = "输入用户"
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    @user.input_by_id = session[:user_id]
    if @user.save
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=用户已保存！")
    else
      flash.now[:error] = '无法保存！'
      render 'new'
    end
  end

  def edit
    @title = "更改用户信息"
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.input_by_id = session[:user_id]
    if @user.update_attributes(params[:user])
      redirect_to URI.escape(SUBURI + "/view_handler?index=0&msg=更改已保存！")
    else
      flash.now[:error] = '修改无法保存！'
      render 'edit'
    end
  end
  
  protected
  
  def return_user_positions(user)
    position = nil
    user.user_levels.each do |ul| 
      if position.nil?
        position = return_position_name(ul.position)
      else
        position = position + ', ' + return_position_name(ul.position)
      end
    end
    return position      
  end
  

end
