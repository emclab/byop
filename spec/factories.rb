# encoding: utf-8
Factory.define :user do |user|
 
  user.name                  "Test User"
  user.login                 'testuser'
  user.email                 "test@test.com"
  user.password              "password1"
  user.password_confirmation "password1"
  user.status                "active"
  user.user_type             "employee"
  user.input_by_id           1

end

Factory.define :user_level do |level|
 
  level.position             "mech_eng"
  level.user_id              1
end

Factory.define :customer do |c|
  c.name                    "test customer"
  c.short_name              "test"   
  c.email                   "t@acom.com"
  c.phone                   "12345678"
  c.cell                    "1234567890"
  c.active                  true
  c.category1_id            2
  c.sales_id                1
  c.address                 "1276 S. Highland Ave, Lombard, IL 67034"
  c.contact                 "Jun C"
  
end

Factory.define :comm_log do |f|
  f.subject                 'about lease'
  f.log                     'talked with customer'
  f.via                     'phone'
  f.purpose                 'initial call'
  f.contact_info            "John Smith, phone 12345"
  f.input_by_id             1
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :name do |n|
  "Person #{n}"
end



