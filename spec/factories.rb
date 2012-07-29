# encoding: utf-8

FactoryGirl.define do
  
  factory :user do 
 
    name                  "Test User"
    login                 'testuser'
    email                 "test@test.com"
    password              "password1"
    password_confirmation "password1"
    status                "active"
    user_type             "employee"
    input_by_id           1

  end

  factory :user_level do 
 
    position             "mech_eng"
    user_id              1
  end

  factory :customer do 
    name                    "test customer"
    short_name              "test"   
    email                   "t@acom.com"
    phone                   "12345678"
    active                  true
    address                 "1276 S. Highland Ave, Lombard, IL 67034"
    contact_info            "Jun C"
    main_biz                "casting"
    equip_by_by             "a caster in 1997"
    installed_equip         "2 10T casters"
    input_by_id             1  
  end

  factory :comm_log do 
    subject                 'about lease'
    log                     'talked with customer'
    via                     'phone'
    purpose                 'initial call'
    contact_with            "John Smith, phone 12345"
    input_by_id             1
  end

  factory :installation do 
    install_name            'a equip'
    inst_eng_id              1
    project_id               1
    start_date               '2012-2-1'
    finish_date              '2012-3-2' 
    completed                false
    input_by_id              1 
  end

  factory :manufacturer do 
    name                    'mfg'
    product                 'product abc' 
    input_by_id              1 
  end

  factory :production do 
    name                    'a prod plan'
    eng_id                   1
    project_id               1
    start_date               '2012-2-1'
    finish_date              '2012-3-2' 
    completed                false
    input_by_id              1   
  end

  factory :quality_issue do 
    name                    'a prod plan'
    issue_desp               'this is a blablabla'
    report_by_id             1
    project_id               1
    report_date              '2012-2-1'
    case_closed              false
    input_by_id              1   
  end

  factory :purchasing do 
    prod_name                'a prod plan'
    spec                     'must have size'
    qty                      2
    unit                     'pcs'
    manufacturer_id          2
    pur_eng_id               1
    project_id               1
    order_date               '2012-2-1'
    delivery_date            '2012-3-2' 
    input_by_id              1
    delivered                false  
    eng_id                   1
    total                    120.20
  end
  
  factory :payment_log do
    pay_date                 Date.new(2012, 4,23)
    amount                   120.00
    input_by_id              1
    purchasing_id            2
  end

  factory :sourcing do  
    prod_name                'a prod plan'
    spec                     'must have size'
    qty                      2
    unit                     'pcs'  
    src_eng_id               1
    project_id               1  
    start_date               '2012-2-1'
    finish_date              '2012-3-2' 
    completed                false  
    total                    120.20   
  end

  factory :project do 
    name                    'project A'
    customer_id              1
    customer_contact_info   'a guy, cell 12345'
    status                  'info collecting'
    tech_spec               '35T, 2000pcs/min'  
    completed                false
  end

  factory :project_log do 
    project_id              1
    subject                 'log name'
    log                     'blaaaaa'
    input_by_id             1
  end

  factory :installation_purchase do 
    part_name                'a prod plan'
    spec                     'must have size'
    qty                      2
    for_what                 'for labor'
    unit                     'pcs'  
    applicant_id             1
    installation_id          1  
    need_date               '2012-2-1'
    input_by_id              1 
    purchased                false   
    total                    65.90  
    warehoused               false      
  end

  factory :installation_purchase_log do 
    installation_purchase_id 1
    log                      'blaaaaa'
    input_by_id              1
  end

  factory :production_log do 
    production_id           1
    log                     'blaaaaa'
    input_by_id             1
  end

  factory :sourcing_log do 
    sourcing_id             1
   log                     'blaaaaa'
    input_by_id             1
  end

  factory :purchasing_log do 
    purchasing_id           1
    log                     'blaaaaa'
    input_by_id             1
  end

  factory :installation_log do 
    installation_id         1
    log                     'blaaaaa'
    input_by_id             1
  end

  factory :src_plant do 
    name                    'sourcing plant'
    short_name              'name'
    primary_contact         'a guy'
    primary_cell            '123455'
    phone                   '23455'
    fax                     '545676'
    address                 '45545,main st'
    input_by_id             1
    sourced_product         'abcd'
    equip                   'stuff'
    active                  true
    quality_system          'ISO9000'
    tech_ability            'great'
    main_product            'value, machinery'
    last_eval_date          '2012/1/1'
  end

  factory :supplier do 
    name                    'sourcing plant'
    short_name              'name'
    contact                 'a guy'
    cell                    '123455'
    phone                   '23455'
    fax                     '35456'
    address                 '45545,main st'
    input_by_id             1  
    product_supplied        'abcdef'
    quality_system          '无'
    main_product            'valve,shaft'
  end

  factory :part do 
    name                    'flow meter'
    spec                    'vse 1040'
    in_qty                  2
    stock_qty               1
    manufacturer            'vse'
    storage_location        'shelf A, 304'
    unit                    'piece'
    in_date                 '2012-2-3'
  end

  factory :out_log do 
    part_id                 1
    out_date                '2012-3-4'
    receiver_id              1
    out_qty                 1
    project_id              2
    for_what                'for fun'
  end

  factory :proj_module do 
    project_id              1
    name                    'blaaaa'  
  end
  
  factory :sys_log do    
    log_date                '2012-2-2'
    user_name               'blabla'
    user_id                 1
    user_ip                 '1.2.3.4'
    action_logged           'create a new user'
  end  

  Factory.sequence :email do 
    "person-#{n}@example.com"
  end

  Factory.sequence :name do 
    "Person #{n}"
  end
  
end



