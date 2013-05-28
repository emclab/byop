# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :box_item do
    shipment_item_id 1
    name "MyString"
    spec "MyString"
    qty 1
    unit "MyString"
    brief_note "MyText"
    input_by_id 1
  end
end
