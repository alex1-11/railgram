require 'rails_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
  it "is a subclass of ActionCable::Connection::Base" do
    expect(ApplicationCable::Connection.superclass).to eq(ActionCable::Connection::Base)
  end
end
