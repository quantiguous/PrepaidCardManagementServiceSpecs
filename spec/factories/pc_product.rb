FactoryGirl.define do
  factory :pc_product, class: PcApp do
    sequence(:code) {|n| "qwe%04i" % "#{n}"}
    is_enabled 'Y'
    mm_host 'https://beta-api.mmvpay.com/inyesm/v1'
    mm_consumer_key 'tcstqKOIjRQzoOy6stF4XVOaAJw5KP7R'
    mm_consumer_secret 'K6dumoioZMgcC2KdEd2L6cZ5ouSNiZpKmQz4i7HL0JtE4aVRIdinTBDDfIYlAjH8'
    mm_card_type 'ybyesmoneycard'
    mm_email_domain 'quantiguous.com'
    mm_admin_host 'https://yesm-ad-uat.mmvpay.com'
    mm_admin_user 'tester+yes@matchmove.com'
    mm_admin_password 'mmg123456'
    card_acct '000590600000122'
    sc_gl_income '1231'
    card_cust_id '2427'
    display_name 'My Name'
    cust_care_no '1234'
    rkb_user 'taisys'
    rkb_password '91ca2dfffd0997f8a7c941538137b114de84a41f'
    rkb_bcagent 'yblesb'
    rkb_channel_partner '140'
    program_code {Factory(:pc_program, :approval_status => 'A').code}
    lock_version 0
    approval_status 'A'
    last_action 'C'
  end
end
