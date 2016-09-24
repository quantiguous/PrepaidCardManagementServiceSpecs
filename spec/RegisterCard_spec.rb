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
  
  let(:appID) { 'MANACLE' }

  def build_request()
    address = ApiBanking::PrepaidCardManagementService::RegisterCard::Address.new()
    idDocument = ApiBanking::PrepaidCardManagementService::RegisterCard::IDDocument.new()
    request = ApiBanking::PrepaidCardManagementService::RegisterCard::Request.new()

    request.address = address
    request.idDocument = idDocument
    
    request
  end

  def registerCard(request)
    ApiBanking::PrepaidCardManagementService.registerCard(request)
  end

  before(:all) do
     # initialize factories   
  end

  after(:all) do
     # destroy factories   
  end
  
  context "with some scenario " do
    before(:each) do
    end

    context "and an empty request" do
      it "should return fault", case: :PPC01  do  
        (request = build_request())
        expect(registerCard(request)).to fail_with('ns:E400')
      end
    end

  end
end
