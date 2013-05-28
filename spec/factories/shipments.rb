# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipment do
    project_id 1
    input_by_id 1
    shipping_date "2013-05-19"
    freight_desp "MyText"
    shipping_via "MyString"
    status "MyString"
    delivery_date "2013-05-19"
    approved_by_ceo false
    approve_ceo_id 1
    approve_date_ceo "2013-05-19"
    customer_signature_by "MyString"
    delivery_address 'this is an address'
  end
end
