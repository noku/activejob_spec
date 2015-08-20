require 'spec_helper'

describe ActiveJobSpec do
  describe '.reset!' do
    before do
      allow(::ActiveJob::Base).
        to receive(:queue_adapter).and_return(double(:enqueued_jobs= => [],
                                                     :performed_jobs= => []))

      ActiveJobSpec.reset!
    end

    it 'assigns [] to the enqueued_jobs or ActiveJob::Base queue adapter' do
      expect(ActiveJob::Base.queue_adapter).to have_received(:enqueued_jobs=).with([])
    end

    it 'assigns [] to the performed_jobs for ActiveJob::Base queue adapter' do
      expect(ActiveJob::Base.queue_adapter).to have_received(:performed_jobs=).with([])
    end
  end
end
