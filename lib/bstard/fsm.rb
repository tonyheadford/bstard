class Bstard::Fsm
  attr_reader :current_state

  def initialize()
    @current_state = :uninitialized
    @events = {}
    @states = []
    @event_callbacks = {}
    @state_callbacks = {}
  end

  def initial(state)
    unless state.nil? || state.empty?
      @current_state = state.to_sym
      add_state(current_state)
    end
  end
  
  def event(event_name, transitions)
    evt = event_name.to_sym
    t = @events.fetch(evt, {})
    @events[evt] = t.merge(transitions)
    transitions.each { |k,v| add_state(k.to_sym); add_state(v.to_sym) }
    add_event_method(evt)
    add_can_event_method(evt)
  end

  def on(event, &block)
    callbacks = @event_callbacks.fetch(event.to_sym, [])
    @event_callbacks[event.to_sym] = callbacks << block
  end

  def when(state, &block)
    callbacks = @state_callbacks.fetch(state.to_sym, [])
    @state_callbacks[state.to_sym] = callbacks << block
  end

  def events
    @events.keys.sort
  end

  def states
    @states.sort
  end

  private

  def add_state(state)
    s = state.to_sym
    unless @states.include? s
      @states << s
      metaclass.send :define_method, "#{s.to_s}?" do
        current_state == s
      end
    end
  end

  def add_event_method(evt)
    unless self.respond_to? evt
      metaclass.send :define_method, "#{evt.to_s}!" do
        transitions = @events[evt]
        raise Bstard::InvalidEvent.new("Unknown event <#{evt.to_s}>") if transitions.nil?
        new_state = transitions[current_state]
        old_state = current_state
        raise Bstard::InvalidTransition.new("Cannot <#{evt.to_s}> from [#{current_state.to_s}]") if new_state.nil?
        @event_callbacks.fetch(evt.to_sym, []).concat(@event_callbacks.fetch(:any, [])).each { |c| c.call(evt, old_state, new_state) }
        @current_state = new_state
        @state_callbacks.fetch(current_state, []).concat(@state_callbacks.fetch(:any, [])).each { |c| c.call(evt, old_state, new_state) }
        new_state
      end
    end
  end

  def add_can_event_method(evt)
    m = "can_#{evt.to_s}?"
    unless self.respond_to? m
      metaclass.send :define_method, m do
        transitions = @events[evt]
        transitions && transitions[current_state]
      end 
    end
  end

  def metaclass
    class << self; self; end
  end
end

