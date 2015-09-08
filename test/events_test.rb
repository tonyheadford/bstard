require 'minitest_helper'

class EventsTest < Minitest::Test
  def setup
    @fsm = Bstard.define do |fsm|
      fsm.initial :pending
      fsm.event :submit, :pending => :submitted
      fsm.event :delete, :submitted => :deleted
    end
  end

  def test_event_adds_event_and_event_helpers
    assert @fsm.events.include?(:submit), 'submit not included in events'
    assert @fsm.events.include?(:delete), 'delete not included in events'
    assert @fsm.respond_to?(:submit!), 'submit! method expected'
    assert @fsm.respond_to?(:delete!), 'delete! method expected'
    assert @fsm.respond_to?(:can_submit?), 'can_submit? method expected'
    assert @fsm.respond_to?(:can_delete?), 'can_delete? method expected'
  end

  def test_event_adds_states_and_state_helpers
    assert @fsm.states.include?(:pending), 'pending not included in states'
    assert @fsm.states.include?(:submitted), 'submitted not included in states'
    assert @fsm.respond_to?(:pending?), 'pending? method expected'
    assert @fsm.respond_to?(:submitted?), 'submitted? method expected'
  end

  def test_event_method_transitions_state
    @fsm.submit!
    assert @fsm.current_state == :submitted
    assert @fsm.submitted?
  end

  def test_event_method_returns_new_state
    s = @fsm.submit!
    assert_equal :submitted, s, "expected :submitted as new state"
    s = @fsm.delete!
    assert_equal :deleted, s, "expected :deleted as new state"
  end

  def test_event_method_raises_error_when_no_transition_available
    @fsm.submit!
    assert_raises Bstard::InvalidTransition do
      @fsm.submit!
    end
  end

  def test_can_event_returns_true_when_transition_possible
    assert @fsm.can_submit?
    refute @fsm.can_delete?
  end

  # @absence_state ||= Bstard.define do |fsm|
  #   fsm.event :submit, :new => :submitted, :draft => :submitted, :redraft => :resubmitted
  #   fsm.event :save, :new => :draft, :draft => :draft, :redraft => :redraft
  #   fsm.event :reset, :submitted => :redraft, :resubmitted => :redraft
  #   fsm.event :delete, :draft => :destroyed, :redraft => :archived
  #   fsm.after_any_event ->(event, state) { @wigwam = state }
  #   fsm.after_delete ->(state) { @thing.destroy if state == :destroyed }
  # end
  # @absence_state ||= Bstard.describe do |fsm|
  #   fsm.initial @persisted_value || :new
  #   fsm.event :submit, :new => :submitted, :draft => :submitted, :redraft => :resubmitted
  #   fsm.event :save, :new => :draft, :draft => :draft, :redraft => :redraft
  #   fsm.event :reset, :submitted => :redraft, :resubmitted => :redraft
  #   fsm.event :delete, :draft => :destroyed, :redraft => :archived
  # end
  # @absence_state.current_state
  # @absence_state.submit!
  # @absence_state.can_submit?
  # @absence_state.save!
  #
end
