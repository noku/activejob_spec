require 'rails/all'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'activejob_spec'

module ActiveJob
  class Base
    def self.queue_adapter
      Struct.new(:enqueued_jobs).new(enqueued_jobs: [])
    end
  end
end
