require 'rspec/expectations'

module RegisterCardMatchers
  extend RSpec::Matchers::DSL
  matcher :be_completed do
    match do |response|
      expect(response).to be_an_instance_of ApiBanking::PrepaidCardManagementService::RegisterCard::Result
    end
    
    failure_message do |response|
      if actual.instance_of?(ApiBanking::Fault)
        "expected result would be RegisterCard::Result instead of #{actual.class} code #{actual.code} : #{actual.subCode} : #{actual.reasonText}"
      else
        "expected result would be RegisterCard::Result instead of #{response}"
      end
    end
  end
end
