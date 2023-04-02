require 'rails_helper'

RSpec.describe ApplicationJob, type: :job do
  it "is a subclass of ActiveJob::Base" do
    expect(ApplicationJob.superclass).to eq(ActiveJob::Base)
  end

  # Uncomment the following specs if you are using the retry_on and discard_on options.

  # it "retries on ActiveRecord::Deadlocked" do
  #   expect(ApplicationJob.retry_on_exceptions).to include(ActiveRecord::Deadlocked)
  # end

  # it "discards on ActiveJob::DeserializationError" do
  #   expect(ApplicationJob.discard_on_exceptions).to include(ActiveJob::DeserializationError)
  # end
end
