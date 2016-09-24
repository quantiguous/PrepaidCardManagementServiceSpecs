require_relative 'BlockCardMatchers'

ActiveRecord::Base.logger = Logger.new(STDOUT)

class BlockCard
  # specify the list of paramaters that are always required to be printed in the report
  def self.param_defaults
    [{appID: nil}, {mobileNo: nil}]
  end
end

RSpec.describe BlockCard do
  include BlockCardMatchers
  
  let(:appID) { 'MANACLE' }

  def build_request()
    request = ApiBanking::PrepaidCardManagementService::BlockCard::Request.new()
    
    request
  end

  def blockCard(request)
    ApiBanking::PrepaidCardManagementService.blockCard(request)
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
        expect(blockCard(request)).to fail_with('ns:E400')
      end
    end

  end
end
