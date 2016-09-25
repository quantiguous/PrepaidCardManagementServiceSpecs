require_relative 'RegisterCardMatchers'

ActiveRecord::Base.logger = Logger.new(STDOUT)

class RegisterCard
  # specify the list of paramaters that are always required to be printed in the report
  def self.param_defaults
    [{appID: nil}, {mobileNo: nil}]
  end
end

RSpec.describe RegisterCard do
  include RegisterCardMatchers
  
  def build_request()
    address = ApiBanking::PrepaidCardManagementService::RegisterCard::Address.new()
    idDocument = ApiBanking::PrepaidCardManagementService::RegisterCard::IDDocument.new()
    request = ApiBanking::PrepaidCardManagementService::RegisterCard::Request.new()

    address.addressLine1 = 'Shankar Lane'
    address.addressLine2 = 'Kandivali'
    address.city = 'Mumbai'
    address.state = 'Maharashtra'
    address.country = 'india'
    address.postalCode = '400101'
    
    idDocument.documentType = 'passport'
    idDocument.documentNo = Time.now.to_i
    idDocument.countryOfIssue = 'india'
    
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'MANACLE'
    request.title = 'Miss'
    request.firstName = 'Divya'
    request.lastName = 'Jayan'
    request.preferredName = 'divya'
    request.mobileNo = Time.now.to_i
    request.gender = 'female'
    request.nationality = 'indian'
    request.birthDate = '1992-12-18'
    request.idDocument = idDocument
    request.address = address
    request.proxyCardNumber = '000000418951'

    request.address = address
    request.idDocument = idDocument

    request
  end

  def registerCard(request)
    ApiBanking::PrepaidCardManagementService.registerCard(request)
  end

  before(:all) do
     # initialize factories
     @pc_program = PcProgram.create(code: 'PROGRAM1', is_enabled: 'Y', lock_version: 0, approval_status: 'A', last_action: 'C')
     @pc_app = PcApp.create(app_id: 'MANACLE', program_code: @pc_program.code, identity_user_id: '12345', is_enabled: 'Y', lock_version: 0, approval_status: 'A', last_action: 'C')
     @pc_product1 = PcProduct.create(code: 'Prod1',
                                   program_code: @pc_program.code,
                                   mm_host: 'https://beta-api.mmvpay.com/inyesm/v1',
                                   mm_consumer_key: 'tcstqKOIjRQzoOy6stF4XVOaAJw5KP7R',
                                   mm_consumer_secret: 'K6dumoioZMgcC2KdEd2L6cZ5ouSNiZpKmQz4i7HL0JtE4aVRIdinTBDDfIYlAjH8',
                                   mm_card_type: 'ybyesmoneycard',
                                   mm_email_domain: 'quantiguous.com',
                                   mm_admin_host: 'https://yesm-ad-uat.mmvpay.com',
                                   mm_admin_user: 'tester+yes@matchmove.com',
                                   mm_admin_password: 'mmg123456',
                                   card_acct: '000590600000122',
                                   sc_gl_income: '1231',
                                   card_cust_id: '2427',
                                   display_name: 'My Name',
                                   cust_care_no: '1234',
                                   rkb_user: 'taisys',
                                   rkb_password: '91ca2dfffd0997f8a7c941538137b114de84a41f',
                                   rkb_bcagent: 'yblesb',
                                   rkb_channel_partner: '140',
                                   is_enabled: 'Y', 
                                   lock_version: 0,
                                   approval_status: 'A',
                                   last_action: 'C')
     @pc_product2 = PcProduct.create(code: 'Prod2',
                                   program_code: @pc_program.code,
                                   mm_host: 'https://beta-api.mmvpay.com/inyesm/v1',
                                   mm_consumer_key: 'tcstqKOIjRQzoOy6stF4XVOaAJw5KP7R',
                                   mm_consumer_secret: 'K6dumoioZMgcC2KdEd2L6cZ5ouSNiZpKmQz4i7HL0JtE4aVRIdinTBDDfIYlAjH8',
                                   mm_card_type: 'ybyesmoneycard',
                                   mm_email_domain: 'quantiguous.com',
                                   mm_admin_host: 'https://yesm-ad-uat.mmvpay.com',
                                   mm_admin_user: 'tester+yes@matchmove.com',
                                   mm_admin_password: 'mmg123456',
                                   card_acct: '000590600000122',
                                   sc_gl_income: '1231', 
                                   card_cust_id: '2427',
                                   display_name: 'My Name',
                                   cust_care_no: '1234',
                                   rkb_user: 'taisys',
                                   rkb_password: '91ca2dfffd0997f8a7c941538137b114de84a41f',
                                   rkb_bcagent: 'yblesb',
                                   rkb_channel_partner: '140',
                                   is_enabled: 'Y', 
                                   lock_version: 0, 
                                   approval_status: 'A', 
                                   last_action: 'C')
  end

  after(:all) do
     @pc_app.delete
     @pc_program.delete
     @pc_product1.delete
     @pc_product2.delete
  end

  context "service faults" do
    context "with an invalid app_id " do
      it "should return fault", case: :PPC01  do
        (request = build_request()).appID = 'BLANK'
        expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1001')
      end
    end
  
    context "with no product for program" do
      it "should return fault", case: :PPC02  do
        @pc_product1.disable!
        @pc_product2.disable!
        (request = build_request()).appID = @pc_app.app_id
        expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1001')
      end
    end
  
    context "with invalid product code for program" do
      it "should return fault", case: :PPC03  do
        @pc_product1.disable!
        @pc_product2.enable!
        (request = build_request()).appID = @pc_app.app_id
        request.productCode = @pc_product1.code
        expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1001')
      end
    end
  
    context "with multiple products for program" do
      it "should return fault", case: :PPC04  do
        @pc_product1.enable!
        @pc_product2.enable!
        (request = build_request()).appID = @pc_app.app_id
        request.productCode = @pc_product1.code
        expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1001')
      end
    end
  end
  
  context "mm_faults" do
    context "with already registered card" do
      it "should return fault", case: :PPC05  do
        @pc_product1.enable!
        @pc_product2.disable!
        (request = build_request()).appID = @pc_app.app_id
        request.productCode = @pc_product1.code
        request.proxyCardNumber = Manacle::DATA['available_proxy_cards']
        expect(registerCard(request)).to be_completed
        
        request.mobileNo = Time.now.to_i
        idDocument.documentNo = Time.now.to_i
        expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1001')
      end
    end
    
    context "with already registered customer" do
      it "should return fault", case: :PPC06  do
        @pc_product1.enable!
        @pc_product2.disable!
        (request = build_request()).appID = @pc_app.app_id
        request.productCode = @pc_product1.code
        request.proxyCardNumber = Manacle::DATA['available_proxy_cards']
        expect(registerCard(request)).to be_completed
        
        request.proxyCardNumber = Manacle::DATA['available_proxy_cards']
        expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1001')
      end
    end
  end
end
