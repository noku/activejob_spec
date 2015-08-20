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

  describe '#have_queued' do
    context 'with a single job in the queue' do
      before do
        enqueued_jobs << { job: AJob, args: [1] }
      end

      it 'have the right parameter passed' do
        expect(AJob).to have_queued(1)
      end
    end

    context 'with multiple jobs in the queue' do
      before do
        enqueued_jobs << { job: AJob, args: [{ test: 1 }, 2] }
        enqueued_jobs << { job: BJob, args: ['random', 3] }
      end

      it 'have right parameters for AJob' do
        expect(AJob).to have_queued({ test: 1 }, 2)
      end

      it 'have right parameters for BJob' do
        expect(BJob).to have_queued('random', 3)
      end

      it 'adds one job to the queue with right parameters' do
        expect(BJob).to have_queued('random', 3).once
      end
    end

    context 'with multiple jobs of the same class' do
      before do
        enqueued_jobs << { job: AJob, args: [1] }
        enqueued_jobs << { job: AJob, args: [1] }
      end

      it 'has the right number of times for AJob' do
        expect(AJob).to have_queued(1).times(2)
      end
    end
  end
end
