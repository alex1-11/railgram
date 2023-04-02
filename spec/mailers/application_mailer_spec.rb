require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  it "is a subclass of ActionMailer::Base" do
    expect(ApplicationMailer.superclass).to eq(ActionMailer::Base)
  end

  it "uses 'from@example.com' as the default 'from' address" do
    expect(ApplicationMailer.default[:from]).to eq("from@example.com")
  end

  it "has the correct default URL options" do
    expect(ApplicationMailer.default_url_options[:host]).to eq("localhost")
    expect(ApplicationMailer.default_url_options[:port]).to eq(3000)
  end

  it "performs deliveries" do
    expect(ApplicationMailer.perform_deliveries).to be_truthy
  end
end
