require_relative 'operations'
require_relative 'BlockCardMatchers'

# ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.describe BlockCard do
  include BlockCardMatchers
  
  let(:appID) { 'MANACLE' }

  def build_request
    BlockCard.build_request
  end

  def blockCard(request)
    ApiBanking::PrepaidCardManagementService.blockCard(request)
  end

  before(:all) do
     @pc_program = PcProgram.create(code: 'PROGRAM1')
     @pc_app = PcApp.create(app_id: 'MANACLE', program_code: @pc_program.code)
     @pc_product1 = PcProduct.create({code: 'prod1', program_code: @pc_program.code}.merge(Manacle::DATA['product_attributes']))
     @pc_product2 = PcProduct.create({code: 'prod2', program_code: @pc_program.code}.merge(Manacle::DATA['product_attributes']))
     
     (@reg_request = RegisterCard.build_request()).appID = @pc_app.app_id
     @reg_request.productCode = @pc_product1.code
     @reg_request.proxyCardNumber = Manacle::DATA['available_proxy_card6']
     ApiBanking::PrepaidCardManagementService.registerCard(@reg_request)
  end

  after(:all) do
     @pc_app.delete
     @pc_program.delete
     @pc_product1.delete
     @pc_product2.delete
  end
  
  context "with a registered mobile" do
    context "with a card which is not blocked" do
      it "should return success", case: :PPCMB2  do
        (request = build_request()).appID = @pc_app.app_id
        request.mobileNo = @reg_request.mobileNo
        expect(blockCard(request)).to be_completed
      end
    end
    context "with a card which is already blocked" do
      it "should return fault", case: :PPCMB3 do
        (request = build_request()).appID = @pc_app.app_id
        request.mobileNo = @reg_request.mobileNo
        expect(blockCard(request)).to fail_with('http:status-400')
      end
    end
  end

  context "with an unregistered mobile" do
    it "should return fault", case: :PPCMB4 do
      (request = build_request()).appID = @pc_app.app_id
      request.mobileNo = Manacle::DATA['unregistered_customer_mobile']
      expect(blockCard(request)).to fail_with('http:status-400')
    end
  end
  
  context "with an invalid app_id " do
    it "should return fault", case: :PPCMB1 do
      (request = build_request()).appID = 'BLANK'
      expect(blockCard(request)).to fail_with('ns:E404')
    end
  end
end
