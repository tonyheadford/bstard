# Bstard - A New State(sman) Machine

A small state machine library with a simple interface. Designed around the concept of aggregation rather than inheritance enabling its use wherever you need it without the need to derive from it or mix it in.

## Installation

Add this line to your application's Gemfile:

``` ruby
gem 'bstard'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bstard

## Usage

Use `Bstard.define` to describe your state machine

``` ruby
  machine = Bstard.define do |fsm|
    fsm.initial :new
    fsm.event :submit, :new => :submitted
    fsm.event :delete, :submitted => :deleted
  end
```

This defines a state machine that:

 - has __new__, __submitted__ and __deleted__ states
 - responds to _submit_ and _delete_ events
 - has an initial state of __new__
 - transitions from __new__ to __submitted__ when triggered by the _submit_ event
 - transitions from __submitted__ to __deleted__ when triggered by the _delete_ event

Pretty simple huh?

### Initial State
Set the initial state of the machine with `initial`. If no initial state is set a default state `:uninitialized` is used.

### Querying the State

The current state of the machine is accessed via the `current_state` method

``` ruby
  machine.current_state
  #=> :new
```

Helper methods are automatically generated for each state consisting of the state name suffixed with a question mark.  This method returns `true` if the current state matches the queried state or `false` otherwise.

``` ruby
  machine.new?
  #=> true
  machine.submitted?
  #=> false
  machine.deleted?
  #=> false
```

### Querying Transitions

Helper methods are dynamically generated to enable querying whether an event can transition the current state.  These methods are named using the event name prefixed with 'can\_' and suffixed with a question mark.

```ruby
  machine.current_state
  #=> :new
  machine.can_submit?
  #=> true
  machine.can_delete?
  #=> false
```

### Triggering Events

Trigger events by sending a message using the event name suffixed with an exclamation mark.

```ruby
  machine.submit!
  #=> :submitted
  machine.delete!
  #=> :deleted
```

### Callbacks

Callbacks can be configured for particular events and state changes, or for _any_ event or state change.
Event callbacks are configured with `on`

``` ruby
  machine = Bstard.define do |fsm|
    # ...
    fsm.on :submit do |event, state, next_state|
      # code that needs to be run when :submit is triggered
    end
  end
```

State change callbacks are configured with `when`

``` ruby
  machine = Bstard.define do |fsm|
    # ...
    fsm.when :submitted do |event, previous_state, state|
      # code that needs to run when state changes to :submitted
    end
  end
```

Use the symbol `:any` for event or state change callbacks that should run when any event is triggered or after any state change.

``` ruby
  machine = Bstard.define do |fsm|
    # ...
    fsm.on :any do |event, state, next_state|
      # code that will run when any event is triggered
    end
    fsm.when :any do |event, previous_state, state|
      # code that will run when after any state change
    end
  end
```

e.g. Use `initial` and `when :any` to persist state

``` ruby
class MyModel < ActiveRecord::Base
  def make_draft
    # do stuff
    state.save!
    save
  end

private
  def state
    @state ||= Bstard.define do |fsm|
      fsm.initial status
      fsm.event :save, :new => :draft
      fsm.event :approve, :draft => :approved
      fsm.when :any do |event, prev_state, new_state|
        status = new_state
      end
    end
  end
end
```

### Exceptions

An `InvalidTransition` error will be raised if an event is triggered on a state that cannot transition on that event.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run `bundle exec rake install`.
To run the tests, run `bundle exec rake test`.

## Contributing

1. Fork it ( https://github.com/tonyheadford/bstard/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

