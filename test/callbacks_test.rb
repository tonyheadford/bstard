require 'minitest_helper'

class CallbacksTest < Minitest::Test
  def setup
    @fsm = Bstard.define do |fsm|
      fsm.initial :pending
      fsm.event :submit, :pending => :submitted
      fsm.event :delete, :submitted => :deleted
      fsm.on :delete do |prev_state|
        puts
      end
      fsm.when :submitted do 
      end
    end
  end

  def test_on_adds_event_callback
    @val = @fsm.current_state
    @fsm.on :submit do |prev_state|
      @val = prev_state
    end
    @fsm.submit!
    assert @val != @fsm.current_state
    assert @val == :pending 
  end

  def test_when_adds_state_change_callback
    @val = @fsm.current_state
    @fsm.when :submitted do |prev_state|
      @val = prev_state
    end
    @fsm.submit!
    assert @val != @fsm.current_state
    assert @val == :pending
  end
end
