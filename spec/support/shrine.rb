# Reference docs and examples: 
#   https://shrinerb.com/docs/testing !
#   https://raghu-bhupatiraju.dev/shrine-testing-in-rspec-f33ff7f03497
#   https://gist.github.com/jovanmaric/34532f425d8c2696119fb3d3a09c9e87

RSpec.configure do |config|
  config.use_transactional_fixtures = false
end
