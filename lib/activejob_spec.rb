require "activejob_spec/version"
require "activejob_spec/matchers"

module ActiveJobSpec
  def self.reset!
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
    ActiveJob::Base.queue_adapter.performed_jobs = []
  end
end
