FactoryGirl.define do
  factory :pc_program, class: PcProgram do
    sequence(:code) {|n| "PC%04i" % "#{n}"}
    is_enabled 'Y'
    lock_version 0
    approval_status 'A'
    last_action 'C'
    
    transient do

    end

    after(:create) do |p,e|
      create(:pc_product, program_code: p.code, account_no: e.active_account_no)
      create(:pc_product, program_code: p.code, account_no: e.inactive_account_no)
    end
  end
end