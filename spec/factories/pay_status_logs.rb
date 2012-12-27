# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pay_status_log do
    payment_log_id 1
    log "blalala"
    input_by_id 1
  end
end
