require 'spec_helper'

describe 'ActiveJobSpec Matchers' do
  class AJob; end
  class BJob; end

  let(:enqueued_jobs) { [] }
  before do
    allow(::ActiveJob::Base).
      to receive(:queue_adapter).and_return(double(enqueued_jobs: enqueued_jobs))
  end

  describe '#have_queue_size_of' do
    context 'when nothing gets enqueued' do
      it 'returns 0 for AJob queue size' do
        expect(AJob).to have_queue_size_of(0)
      end

      it 'returns 0 for BJob queue size' do
        expect(BJob).to have_queue_size_of(0)
      end
    end

    context 'with a single job in the queue' do
      before do
        enqueued_jobs << { job: AJob, args: [] }
      end

      it 'returns 1 for Ajob queue size' do
        expect(AJob).to have_queue_size_of(1)
      end

      it 'returns 0 for Bjob queue size' do
        expect(BJob).to have_queue_size_of(0)
      end
    end

    context 'with multiple jobs in the queue' do
      before do
        enqueued_jobs << { job: AJob, args: [] }
        enqueued_jobs << { job: BJob, args: [] }
      end

      it 'returns 1 for Ajob queue size' do
        expect(AJob).to have_queue_size_of(1)
      end

      it 'returns 1 for Bjob queue size' do
        expect(BJob).to have_queue_size_of(1)
      end
    end
  end
end
