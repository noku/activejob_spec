require 'rspec/core'
require 'rspec/expectations'
require 'rspec/mocks'

module ArgsHelper
  def match_job(job, klass)
    job.fetch(:job) == klass
  end

  def match_args(expected_args, args)
    arg_list_matcher = RSpec::Mocks::ArgumentListMatcher.new(expected_args)
    arg_list_matcher.args_match?(args)
  end
end

module QueueHelper
  include ArgsHelper
  include ActiveJob::TestHelper

  def find_matching_jobs(actual, expected_args)
    enqueued_jobs.select do |entry|
      match_job(entry, actual) && match_args(expected_args, entry.fetch(:args))
    end
  end

  def queue_size_for(klass)
    enqueued_jobs.select { |job| match_job(job, klass) }.size
  end

  def enqueued_jobs
    ::ActiveJob::Base.queue_adapter.enqueued_jobs
  end

  def check_size_for(matched_jobs, times)
    if times
      matched_jobs.size == times
    else
      matched_jobs.size > 0
    end
  end
end

module ScheduleQueueHelper
  include QueueHelper

  def check_if_scheduled(actual, expected_args)
    scheduled_jobs.any? do |entry|
      class_matches = match_job(entry, actual)
      args_match = match_args(expected_args, entry.fetch(:args))

      class_matches && args_match && time_matches(entry)
    end
  end

  def time_matches(entry)
    return compare_time(entry) if @time
    return compare_interval(entry) if @interval

    true
  end

  def compare_time(entry)
    entry[:at].to_i == @time.to_i
  end

  def compare_interval(entry)
    entry[:at].to_i == (Time.now + @interval).to_i
  end

  def scheduled_jobs
    enqueued_jobs.select { |job| job.key?(:at) }
  end

  def scheduled_size_for(klass)
    scheduled_jobs.select { |job| match_job(job, klass) }.size
  end
end

RSpec::Matchers.define :have_queued do |*expected_args|
  include QueueHelper

  chain :times do |num_times_queued|
    @times = num_times_queued
    @times_info = (@times == 1 ? ' once' : " #{@times} times")
  end

  chain :once do
    @times = 1
    @times_info = ' once'
  end

  match do |actual|
    matched_jobs = find_matching_jobs(actual, expected_args)

    check_size_for(matched_jobs, @times)
  end

  failure_message do |actual|
    "expected that #{actual} would have [#{expected_args.join(', ')}] queued#{@times_info}"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not have [#{expected_args.join(', ')}] queued#{@times_info}"
  end

  description do
    "have queued arguments of [#{expected_args.join(', ')}]#{@times_info}"
  end
end

RSpec::Matchers.define :have_queue_size_of do |size|
  include QueueHelper

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

RSpec::Matchers.define :have_scheduled do |*expected_args|
  include ScheduleQueueHelper

  chain :at do |timestamp|
    @interval = nil
    @time = timestamp
    @time_info = "at #{@time}"
  end

  chain :in do |interval|
    @time = nil
    @interval = interval
    @time_info = "in #{@interval} seconds"
  end

  match do |actual|
    check_if_scheduled(actual, expected_args)
  end

  failure_message do |actual|
    ["expected that #{actual} would have [#{expected_args.join(', ')}] scheduled", @time_info].join(' ')
  end

  failure_message_when_negated do |actual|
    ["expected that #{actual} would not have [#{expected_args.join(', ')}] scheduled", @time_info].join(' ')
  end

  description do
    "have scheduled arguments"
  end
end

RSpec::Matchers.define :have_schedule_size_of do |size|
  include ScheduleQueueHelper

  match do |actual|
    scheduled_size_for(actual) == size
  end

  failure_message do |actual|
    "expected that #{actual} would have #{size} entries scheduled, but got #{queue_size_for(actual)} instead"
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not have #{size} entries scheduled, but got #{queue_size_for(actual)} instead"
  end

  description do
    "have a scheduled queue size of #{size}"
  end
end
