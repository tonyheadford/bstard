require 'minitest_helper'

class BstardTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Bstard::VERSION
  end

  def test_define_returns_a_new_instance
    assert_instance_of Bstard::Fsm,  Bstard.define
  end

  def test_initial_sets_initial_state
    b = Bstard.define do |fsm|
      fsm.initial :start
    end

    assert b.current_state == :start, 'current_state is not :start'
  end

  def test_initial_adds_state_to_states
    b = Bstard.define do |fsm|
      fsm.initial :start
    end
    assert b.states.include?(:start), 'start not included in states'
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
