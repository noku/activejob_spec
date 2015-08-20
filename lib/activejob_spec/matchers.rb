require 'rspec/core'
require 'rspec/expectations'
require 'rspec/mocks'

module InQueueHelper
  include ActiveJob::TestHelper

  def queue_size_for(klass)
    enqueued_jobs.select { |job| job.fetch(:job) == klass }.size
  end

  def enqueued_jobs
    ::ActiveJob::Base.queue_adapter.enqueued_jobs
  end
end

RSpec::Matchers.define :have_queue_size_of do |size|
  include InQueueHelper

  match do |actual|
    queue_size_for(actual) == size
  end

  failure_message do |actual|
    "expected that #{actual} would have #{size} entries queued, but got #{queue_size_for(actual)} instead"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not have #{size} entries queued, but got #{queue_size_for(actual)} instead"
  end

  description do
    "have a queue size of #{size}"
  end
end
