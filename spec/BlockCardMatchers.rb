require 'rspec/expectations'

module BlockCardMatchers
  extend RSpec::Matchers::DSL
  matcher :be_completed do
    match do |response|
      p response.try(:uniqueResponseNo)
      expect(response).to be_an_instance_of ApiBanking::PrepaidCardManagementService::BlockCard::Result
    end
    
    failure_message do |response|
      if actual.instance_of?(ApiBanking::Fault)
        "expected result should be BlockCard::Result instead of #{actual.class} code #{actual.code} : #{actual.subCode} : #{actual.reasonText}"
      else
        "expected result should be BlockCard::Result instead of #{response} "
      end
    end
  end
end
