require 'minitest_helper'

class CallbacksTest < Minitest::Test
  def setup
    @fsm = Bstard.define do |fsm|
      fsm.initial :pending
      fsm.event :submit, :pending => :submitted
      fsm.event :delete, :submitted => :deleted
    end
  end

  def test_on_adds_event_callback
    @val = @fsm.current_state
    @fsm.on :submit do |event, state, next_state|
      @val = state
    end
    @fsm.submit!
    assert @val != @fsm.current_state
    assert @val == :pending 
  end

  def test_when_adds_state_change_callback
    val = @fsm.current_state
    @fsm.when :submitted do |event, prev_state, state|
      val = prev_state
    end
    @fsm.submit!
    assert val != @fsm.current_state
    assert val == :pending
  end

  def test_on_passes_event_current_and_next_state_to_block
    cs = @fsm.current_state
    ev = nil
    s = nil
    ns = nil
    @fsm.on :submit do |e, c, n|
      ev = e
      s = c
      ns = n
    end
    @fsm.submit!
    assert_equal cs, s, "current state did not equal #{cs}"
    assert_equal :submitted, ns, "new state did not equal :submitted"
    assert_equal :submit, ev, "event did not equal :submit"
  end

  def test_when_passes_event_previous_and_current_state_to_block
    cs = @fsm.current_state
    ev = nil
    ps = nil
    ns = nil
    @fsm.when :submitted do |e, p, c|
      ev = e
      ps = p
      ns = c
    end
    @fsm.submit!
    assert_equal cs, ps, "previous state did not equal #{cs}"
    assert_equal :submitted, ns, "new state did not equal :submitted"
    assert_equal :submit, ev, "event did not equal :submit"
  end
end
