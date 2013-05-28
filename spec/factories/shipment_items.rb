# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shipment_item do
    shipment_id 1
    input_by_id 1
    name "MyString"
    spec "MyString"
    qty 1
    unit "MyString"
    brief_note "MyText"
    box false
  end
end
