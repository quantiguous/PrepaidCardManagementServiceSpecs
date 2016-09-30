require_relative 'operations'
require_relative 'LoadCardMatchers'
# require 'ruby-debug'

# ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.describe LoadCard do
  include LoadCardMatchers
  
  let(:appID) { 'MANACLE' }

  def build_request()
    LoadCard.build_request
  end

  def loadCard(request)
    ApiBanking::PrepaidCardManagementService.loadCard(request)
  end

  before(:all) do
     p @abc
     @ar = {}
     @ar[:pc_program] = PcProgram.create(code: 'PROGRAM1')
     @ar[:pc_app] = PcApp.create(app_id: 'MANACLE', program_code: @ar[:pc_program].code)
     @ar[:pc_product1] = PcProduct.create({code: 'prod1', program_code: @ar[:pc_program].code}.merge(Manacle::DATA['product_attributes']))
     @ar[:pc_product2] = PcProduct.create({code: 'prod2', program_code: @ar[:pc_program].code}.merge(Manacle::DATA['product_attributes']))

     # register the proxy_card if not already registered
     (request = RegisterCard.build_request()).appID = @ar[:pc_app].app_id
     request.productCode = @ar[:pc_product1].code
     request.proxyCardNumber = Manacle::DATA['available_proxy_card6']
     @mobileNo = request.mobileNo
     if ApiBanking::PrepaidCardManagementService.registerCard(request).instance_of?(ApiBanking::Fault)
       @ar.each { |k,v| v.delete }
       raise "registration failed "
     end
  end

  after(:all) do
    @ar.each { |k,v| v.delete }
  end
  
  context "with a registered mobile" do
    context "with valid debit account number" do
      it "should return success", case: :PPCML2  do
        (request = build_request()).appID = @pc_app.app_id
        request.mobileNo = @mobileNo
        expect(loadCard(request)).to be_completed
      end
    end
    # context "with invalid debit account number" do
    #   it "should return fault", case: :PPCML3 do
    #     (request = build_request()).appID = @pc_app.app_id
    #     request.mobileNo = @mobileNo
    #     request.debitAccountNo = Manacle::DATA['invalid_debit_account_no']
    #     expect(loadCard(request)).to fail_with('ns:E502')
    #   end
    # end
  end
  
  context "with an unregistered mobile" do
    it "should return fault", case: :PPCML4 do
      (request = build_request()).appID = @pc_app.app_id
      request.mobileNo = Manacle::DATA['unregistered_customer_mobile']
      expect(loadCard(request)).to fail_with('http:status-400')
    end
  end
  
  context "with an invalid app_id " do 
    it "should return fault", case: :PPCML1  do
      (request = build_request()).appID = 'BLANK'
      expect(loadCard(request)).to fail_with('ns:E404')
    end
  end
end
