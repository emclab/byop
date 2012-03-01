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
  c.active                  true
  c.address                 "1276 S. Highland Ave, Lombard, IL 67034"
  c.contact_info            "Jun C"
  c.main_biz                "casting"
  c.equip_by_by             "a caster in 1997"
  c.installed_equip         "2 10T casters"
  c.input_by_id             1  
end

Factory.define :comm_log do |f|
  f.subject                 'about lease'
  f.log                     'talked with customer'
  f.via                     'phone'
  f.purpose                 'initial call'
  f.contact_with            "John Smith, phone 12345"
  f.input_by_id             1
end

Factory.define :installation do |f|
  f.install_name            'a equip'
  f.inst_eng_id              1
  f.project_id               1
  f.start_date               '2012-2-1'
  f.finish_date              '2012-3-2' 
  f.completed                false
  f.input_by_id              1 
end

Factory.define :manufacturer do |f|
  f.name                    'mfg'
  f.product                 'product abc' 
  f.input_by_id              1 
end

Factory.define :production do |f|
  f.name                    'a prod plan'
  f.eng_id                   1
  f.project_id               1
  f.start_date               '2012-2-1'
  f.finish_date              '2012-3-2' 
  f.completed                false
  f.input_by_id              1   
end

Factory.define :purchasing do |f|
  f.prod_name                'a prod plan'
  f.spec                     'must have size'
  f.qty                      2
  f.unit                     'pcs'
  f.manufacturer_id          2
  f.pur_eng_id               1
  f.project_id               1
  f.order_date               '2012-2-1'
  f.delivery_date            '2012-3-2' 
  f.input_by_id              1
  f.delivered                false  
  f.eng_id                   1
end

Factory.define :sourcing do |f| 
  f.prod_name                'a prod plan'
  f.spec                     'must have size'
  f.qty                      2
  f.unit                     'pcs'  
  f.src_eng_id               1
  f.project_id               1  
  f.start_date               '2012-2-1'
  f.finish_date              '2012-3-2' 
  f.completed                false     
end

Factory.define :project do |f|
  f.name                    'project A'
  f.customer_id              1
  f.customer_contact_info   'a guy, cell 12345'
  f.status                  'info collecting'
  f.tech_spec               '35T, 2000pcs/min'  
end

Factory.define :project_log do |f|
  f.project_id              1
  f.subject                 'log name'
  f.log                     'blaaaaa'
  f.input_by_id             1
end

Factory.define :production_log do |f|
  f.production_id           1
  f.log                     'blaaaaa'
  f.input_by_id             1
end

Factory.define :sourcing_log do |f|
  f.sourcing_id             1
  f.log                     'blaaaaa'
  f.input_by_id             1
end

Factory.define :purchasing_log do |f|
  f.purchasing_id           1
  f.log                     'blaaaaa'
  f.input_by_id             1
end

Factory.define :installation_log do |f|
  f.installation_id         1
  f.log                     'blaaaaa'
  f.input_by_id             1
end

Factory.define :src_plant do |f|
  f.name                    'sourcing plant'
  f.short_name              'name'
  f.primary_contact         'a guy'
  f.primary_cell            '123455'
  f.phone                   '23455'
  f.fax                     '545676'
  f.address                 '45545,main st'
  f.input_by_id             1
  f.sourced_product         'abcd'
  f.equip                   'stuff'
  f.active                  true
  f.quality_system          'ISO9000'
  f.tech_ability            'great'
  f.main_product            'value, machinery'
  f.last_eval_date          '2012/1/1'
end

Factory.define :supplier do |f|
  f.name                    'sourcing plant'
  f.short_name              'name'
  f.contact                 'a guy'
  f.cell                    '123455'
  f.phone                   '23455'
  f.fax                     '35456'
  f.address                 '45545,main st'
  f.input_by_id             1  
  f.product_supplied        'abcdef'
  f.active                  true
  f.quality_system          '无'
  f.main_product            'valve,shaft'
end

Factory.define :proj_module do |f|
  f.project_id              1
  f.name                    'blaaaa'  
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :name do |n|
  "Person #{n}"
end



