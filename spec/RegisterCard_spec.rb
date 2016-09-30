require_relative 'operations'
require_relative 'RegisterCardMatchers'

# ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.describe RegisterCard do
  include RegisterCardMatchers
  
  def build_request()
    RegisterCard.build_request
  end

  def registerCard(request)
    ApiBanking::PrepaidCardManagementService.registerCard(request)
  end

  before(:all) do
    @pc_program = PcProgram.create(code: 'PROGRAM1')
    @pc_app = PcApp.create(app_id: 'MANACLE', program_code: @pc_program.code)
    @pc_product1 = PcProduct.create({code: 'prod1', program_code: @pc_program.code}.merge(Manacle::DATA['product_attributes']))
    @pc_product2 = PcProduct.create({code: 'prod2', program_code: @pc_program.code}.merge(Manacle::DATA['product_attributes']))
  end

  after(:all) do
    @pc_app.delete
    @pc_program.delete
    @pc_product1.delete
    @pc_product2.delete
  end

  context "with an invalid app_id " do
    it "should return fault", case: :PPCMR6  do
      (request = build_request()).appID = 'BLANK'
      expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1001')
    end
  end

  context "with valid product code" do
    context "with a non-registered card" do
      it "should return success", case: :PPCMR5 do
        @pc_product1.enable!
        (request = build_request()).appID = @pc_app.app_id
        request.productCode = @pc_product1.code
        request.proxyCardNumber = Manacle::DATA['available_proxy_card1']
        expect(registerCard(request)).to be_completed
      end
    end

    context "with already registered card" do
      it "should return fault", case: :PPCMR6 do
        @pc_product1.enable!
        (request = build_request()).appID = @pc_app.app_id
        request.productCode = @pc_product1.code
        request.proxyCardNumber = Manacle::DATA['available_proxy_card2']
        expect(registerCard(request)).to be_completed

        request.mobileNo = Time.now.to_i
        request.idDocument.documentNo = Time.now.to_i
        request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
        expect(registerCard(request)).to fail_with('http:status-400')
      end
    end

    context "with already registered customer" do
      it "should return fault", case: :PPCMR7  do
        @pc_product1.enable!
        (request = build_request()).appID = @pc_app.app_id
        request.productCode = @pc_product1.code
        request.proxyCardNumber = Manacle::DATA['available_proxy_card3']
        expect(registerCard(request)).to be_completed

        request.proxyCardNumber = Manacle::DATA['available_proxy_card4']
        request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
        expect(registerCard(request)).to fail_with('http:status-400')
      end
    end
  end

  context "with invalid product code" do
    it "should return fault", case: :PPCMR4 do
      @pc_product1.enable!
      @pc_product2.disable!
      (request = build_request()).appID = @pc_app.app_id
      request.productCode = @pc_product2.code
      request.proxyCardNumber = Manacle::DATA['available_proxy_card1']
      expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1002')
    end
  end

  context "without product code" do
    context "with app_id assigned to program having only one product" do
      it "should return success", case: :PPCMR2 do
        @pc_product1.enable!
        @pc_product2.disable!
        (request = build_request()).appID = @pc_app.app_id
        request.proxyCardNumber = Manacle::DATA['available_proxy_card5']
        expect(registerCard(request)).to be_completed
      end
    end

    context "with app_id assigned to program having multiple products" do
      it "should return fault", case: :PPCMR3 do
        @pc_product1.enable!
        @pc_product2.enable!
        (request = build_request()).appID = @pc_app.app_id
        request.proxyCardNumber = Manacle::DATA['available_proxy_card1']
        expect(registerCard(request)).to fail_with('ns:E400', 'ns:E1003')
      end
    end
  end

  #TODO
  context "retry" do
    # it "should return success", case: :PPC08 do
    #   @pc_product1.enable!
    #   @pc_product2.disable!
    #   (request = build_request()).appID = @pc_app.app_id
    #   request.productCode = @pc_product1.code
    #   request.proxyCardNumber = Manacle::DATA['available_proxy_card1']
    #   expect(registerCard(request)).to be_completed
    #
    #   pc_customer = PcCustomer.find_by(mobile_no: request.mobileNo, program_code: @pc_program.code)
    #   pc_customer.disable!
    #   request.proxyCardNumber = Manacle::DATA['available_proxy_card2']
    #   request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    #   expect(registerCard(request)).to fail_with('http:status-400')
    # end
  end
  
  
end
