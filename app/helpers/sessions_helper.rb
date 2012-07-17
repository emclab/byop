# encoding: utf-8
module SessionsHelper
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    set_user_rights
  end  

  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
    reset_session
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, "remove_fields(this)")
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render :partial => association.to_s, :locals => {:f => builder, :i_id => 0} 
    end
    link_to_function(name, "add_fields(this, \"#{association}\", \"#{j fields}\")")
  end
    
  def employee?
    session[:employee]
  end

  def src_plant?
    session[:src_plant]
  end  
    
  def ceo?
    session[:ceo]
  end
  
  def coo?
    session[:coo]
  end  
  
  def admin?
    session[:admin]
  end
  
  def vp_eng?
    session[:vp_eng]
  end
  
  def vp_sales?
    session[:vp_sales]
  end 
  
  def comp_sec?
    session[:comp_sec]
  end 
  
  def acct?
    session[:acct]
  end
  
  def warehouse?
    session[:warehouse]
  end
  
  def mech_eng?
    session[:mech_eng]
  end
  
  def elec_eng?
    session[:elec_eng]
  end
  
  def hydr_eng?
    session[:hydr_eng]
  end
  
  def inst_eng?
    session[:inst_eng]
  end
  
  def pur_eng?
    session[:pur_eng]
  end
  
  def src_eng?
    session[:src_eng]
  end
  
  def qc_eng?
    session[:qc_eng]
  end
  
  def is_eng?
    mech_eng? || elec_eng? || hydr_eng? || src_eng? || inst_eng? || pur_eng? || qc_eng?
  end
  
  def is_tech_eng?
    mech_eng? || elec_eng? || hydr_eng? || src_eng? || inst_eng? || qc_eng?
  end
    
  def return_active_customer
    Customer.active_cust.order("id DESC")  
  end
    
  #def return_eng
  #  User.where("user_type =? AND status =?", 'employee', 'active').joins(:user_levels).where(:user_levels => { :position => ['mech_eng', 'hydr_eng', 'inst_eng', 'elec_eng', 'src_eng', 'pur_eng']})
  #end
  
  
  def return_employee(*list_position)
    User.where("user_type = ? AND status = ?", 'employee', 'active').joins(:user_levels).where(:user_levels => {:position => list_position })
  end
  
  def return_mfg
    Manufacturer.order("name")
  end
  
  def return_supplier
    Supplier.active_supplier.order("name")
  end

  def return_src_plant
    SrcPlant.active_plant.order("name")
  end
  
  def return_proj_module(project)
    project.proj_modules.order("name")  

  end
  
  def return_project_status
    ['项目资料收集','投标前接触客户', '通过投标资格审查', '收到标书','已投标','投标后交流', '未中标','再投标', '已中标','中标-技术谈判','中标-合同谈判','合同已签','生产计划', '设备设计等开始','设备设计等完成过半','甲方设计审查','设备外协&外购开始','设备生产完成过半','甲方出厂前设备验收','设备准备发运', '设备已发运','设备安装中','设备调试中','设备试生产','设备验收合格','设备交付']
  end
  
  def return_unit
    ['件','个', '台', '套', '支', '组', '根', '只', '公斤', '克', '米', '升', '毫升', '加仑', '立方米']
  end
  
  def return_yes_no
    [['是',true ],['否', false]]
  end
  
  def return_yes_no_name(b)
    case b
    when true || 'true' || 1 || '1'
      return '是'
    when false || 'false' || 0 || '0'
      return '否'
    else
      return '未定'
    end
    
  end
  
  def return_user_status
    [['在职', 'active'], ['禁止登录','blocked'], ['离职', 'inactive']]
  end
  
  def return_user_status_name(status)
    case status
    when 'active'
      '在职'
    when 'blocked'
      '禁止登录'
    when 'inactive'
      '离职'
    end
  end
  
  def return_user_type
    [['北冶员工', 'employee'], ['外协厂商','src_plant']]
  end
  
  def return_user_type_name(name)
    case name
    when 'employee'
      '北冶员工'
    when 'src_plant'
      '外协厂商'
    end
  end
 
  def return_position
    [['机械工程师', 'mech_eng'], ['电气工程师', 'elec_eng'], ['液压工程师', 'hydr_eng'],['安装工程师','inst_eng'], ['外协工程师','src_eng'], 
     ['采购工程师','pur_eng'], ['质检工程师','qc_eng'],['仓库保管员','warehouse'], ['财会','acct'], ['行政秘书','comp_sec'], ['系统管理员','admin'],
     ['工程副总','vp_eng'], ['市场副总', 'vp_sales'], ['总经理','coo'],['董事长','ceo']]
  end
  
  def return_position_name(position)
    case position
    when 'mech_eng'
      '机械工程师'
    when 'elec_eng'
      '电气工程师'
    when 'hydr_eng'
      '液压工程师'
    when 'inst_eng'
      '安装工程师'
    when 'src_eng'
      '外协工程师'
    when 'pur_eng'
      '采购工程师'
    when 'qc_eng'
      '质检工程师'
    when 'warehouse'
      '仓库保管员'
    when 'acct'
      '财会'
    when 'comp_sec'
      '行政秘书'
    when 'admin'
      '系统管理员'
    when 'vp_eng'
      '工程副总'
    when 'vp_sales'
      '市场副总'
    when 'coo'
      '总经理'
    when 'ceo'
      '董事长'
    end
  end
  
  def set_contact_via
    return ["电话", "会面/议", "电邮" ,"传真"]
  end
  
  def set_contact_purpose
    return ["具体业务", "联络感情", "初次联系", "销售推广", "追踪联系", "产品介绍"]
  end  
   
  def return_quality_system
    ['无', 'ISO9000', 'ISO14001', 'TS16949']  
  end
  
  def return_active_plant
    SrcPlant.active_plant  
  end
  
  def returen_active_supplier
    Supplier.active_supplier
  end
  
  private

   def user_from_remember_token
     User.authenticate_with_salt(*remember_token)
   end

   def remember_token
     cookies.signed[:remember_token] || [nil, nil]
   end

   def current_user=(user)
     @current_user = user
   end  
      
   def set_user_rights
     session[current_user.user_type.to_sym] = true 
     
     self.current_user.user_levels.each do |r|
       session[r.position.to_sym] = true 
     end
   end

end  # module  

