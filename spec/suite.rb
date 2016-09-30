RSpec.configure do |config|
  config.before(:suite) do
    p "ran"
    @abc = '1'
    p @abc
  end
  
  config.after(:suite) do
    p @abc
    p "end"
    
  end
end
