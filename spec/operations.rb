class RegisterCard
  # specify the list of paramaters that are always required to be printed in the report
  def self.param_defaults
    [{appID: nil}, {mobileNo: nil}]
  end
  
  def self.build_request
    address = ApiBanking::PrepaidCardManagementService::RegisterCard::Address.new()
    idDocument = ApiBanking::PrepaidCardManagementService::RegisterCard::IDDocument.new()
    request = ApiBanking::PrepaidCardManagementService::RegisterCard::Request.new()

    address.addressLine1 = 'Shankar Lane'
    address.addressLine2 = 'Kandivali'
    address.city = 'Mumbai'
    address.state = 'Maharashtra'
    address.country = 'india'
    address.postalCode = '400101'

    idDocument.documentType = 'u_bill'
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
end

class LoadCard
  # specify the list of paramaters that are always required to be printed in the report
  def self.param_defaults
    [{appID: nil}, {mobileNo: nil}]
  end
  
  def self.build_request
    request = ApiBanking::PrepaidCardManagementService::LoadCard::Request.new()
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'MANACLE'
    request.customerID = '2427'
    request.debitAccountNo = Manacle::DATA['debit_account_no']
    request.mobileNo = '9008888888'
    request.loadAmount = '1000'
    request
  end
end

class BlockCard
  # specify the list of paramaters that are always required to be printed in the report
  def self.param_defaults
    [{appID: nil}, {mobileNo: nil}]
  end
  
  def self.build_request()
    request = ApiBanking::PrepaidCardManagementService::BlockCard::Request.new()
    request.uniqueRequestNo = SecureRandom.uuid.gsub!('-','')
    request.appID = 'MANACLE'
    request.mobileNo = Time.now.to_i
    request
  end
end
