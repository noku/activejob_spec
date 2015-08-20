# ActiveJobSpec

A test double of ActiveJob for RSpec.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activejob_spec'
```

or

```ruby
  group :development, :test do
    gem 'activejob_spec'
  end
```

## Usage

Given this scenario

    Given a payment
    When I process
    Then the payment has process queued

And I write this spec using the `activejob_spec` matcher

```ruby
describe '#process' do
  before do
    ActiveJobSpec.reset!
  end

  it 'adds payment.process to the Payment queue' do
    payment.process
    expect(Payment).to have_queued(payment.id)

    # also possible with :once and :times methods
    # expect(Payment).to have_queued(payment.id).once
  end
end
```

And I see that the `have_queued` assertion is asserting that the `Payment` queue has a job with arguments `payment.id` and `:process`

And I take note of the `before` block that is calling `reset!` for every spec.

You can check the size of the queue in your specs too.

```ruby
describe '#process' do
  before do
    ActiveJobSpec.reset!
  end

  it 'adds an entry to the Payment queue' do
    payment.process
    expect(Payment).to have_queue_size_of(1)
  end
end
```

## Scheduled Jobs

Given this scenario

    Given a payment
    When I schedule a process
    Then the payment has process scheduled

And I write this spec using the `activejob_spec` matcher

```ruby
describe '#process' do
  before do
    ActiveJobSpec.reset!
  end

  it 'adds payment.process to the Payment queue' do
    payment.process

    expect(Payment).to have_scheduled(payment.id)
  end
end
```

And I might use the `at` statement to specify the time:

```ruby
describe "#process" do
  before do
    ActiveJobSpec.reset!
  end

  it 'adds payment.process to the Payment queue' do
    payment.process

    # Is it scheduled to be executed at 2010-02-14 06:00:00 ?
    expect(Payment).to have_scheduled(payment.id).at(Time.mktime(2010,2,14,6,0,0))
  end
end
```

And I might use the `in` statement to specify time interval (in seconds):

```ruby
describe '#process' do
  before do
    ActiveJobSpec.reset!
  end

  it 'adds payment.process to the Payment queue' do
    payment.process

    # Is it scheduled to be executed in 5 minutes?
    expect(Payment).to have_scheduled(payment.id).in(5 * 60)
  end
end
```

You can also check the size of the schedule:

```ruby
describe "#process" do
  before do
    ActiveJobSpec.reset!
  end

  it "adds payment.calculate to the Payment queue" do
    payment.process

    expect(Payment).to have_schedule_size_of(1)
  end
end
```

(And I take note of the `before` block that is calling `reset!` for every spec)

## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it.
* Send a pull request.

## License

Copyright (c) 2015 Peter Negrei. See LICENSE for details.
