# ActiveJobSpec

A test double of ActiveJob for RSpec.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'activejob_spec'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activejob_spec

or

    group :test do
      gem 'activejob_spec'
    end

## Usage

Given this scenario

    Given a payment
    When I process
    Then the payment has process queued

And I write this spec using the `activejob_spec` matcher

```ruby
describe "#process" do
  before do
    ActiveJobSpec.reset!
  end

  it "adds payment.process to the Payment queue" do
    payment.process
    expect(Payment).to have_queued(payment.id, :process)
  end
end
```

And I see that the `have_queued` assertion is asserting that the `Payment` queue has a job with arguments `payment.id` and `:process`

And I take note of the `before` block that is calling `reset!` for every spec.

You can check the size of the queue in your specs too.

```ruby
describe "#process" do
  before do
    ActiveJobSpec.reset!
  end

  it "adds an entry to the Payment queue" do
    payment.process
    expect(Payment).to have_queue_size_of(1)
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/activejob_spec. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

