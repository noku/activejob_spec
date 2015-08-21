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

  describe '#have_scheduled' do
    context 'without scheduled any job in the queue' do
      before do
        enqueued_jobs << { job: AJob, args: ['id'] }
      end

      it 'does not have a scheduled job for Ajob' do
        expect(AJob).not_to have_scheduled('id')
      end
    end

    context 'with a scheduled job' do
      before do
        enqueued_jobs << { job: AJob, args: ['id'], at: 3.days.from_now }
      end

      it 'has a scheduled job for AJob' do
        expect(AJob).to have_scheduled('id')
      end

      it 'has a scheduled job at right time for AJob' do
        expect(AJob).to have_scheduled('id').at(3.days.from_now)
      end

      it 'has a scheduled job in specifend interval for AJob' do
        expect(AJob).to have_scheduled('id').in(3.days)
      end
    end
  end

  describe '#have_schedule_size_of' do
    context 'when nothing gets enqueued' do
      it 'returns 0 for AJob scheduled size' do
        expect(AJob).to have_schedule_size_of(0)
      end

      it 'returns 0 for BJob scheduled size' do
        expect(BJob).to have_schedule_size_of(0)
      end
    end

    context 'with a single job in the scheduled' do
      before do
        enqueued_jobs << { job: AJob, args: [], at: 3.days.from_now }
      end

      it 'returns 1 for Ajob scheduled size' do
        expect(AJob).to have_schedule_size_of(1)
      end

      it 'returns 0 for Bjob scheduled size' do
        expect(BJob).to have_schedule_size_of(0)
      end
    end

    context 'with multiple jobs in the scheduled' do
      before do
        enqueued_jobs << { job: AJob, args: [], at: 3.days.from_now }
        enqueued_jobs << { job: BJob, args: [], at: 3.days.from_now }
      end

      it 'returns 1 for Ajob scheduled size' do
        expect(AJob).to have_schedule_size_of(1)
      end

      it 'returns 1 for Bjob scheduled size' do
        expect(BJob).to have_schedule_size_of(1)
      end
    end
  end
end
