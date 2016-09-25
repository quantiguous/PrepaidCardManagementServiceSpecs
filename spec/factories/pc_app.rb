FactoryGirl.define do
  factory :pc_app, class: PcApp do
    sequence(:app_id) {|n| "XYZ%04i" % "#{n}"}
    is_enabled 'Y'
    lock_version 0
    approval_status 'A'
    last_action 'C'
  end
end
