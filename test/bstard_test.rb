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

  def test_initial_state_converted_to_symbol
    b = Bstard.define do |fsm|
      fsm.initial "wigwam"
    end
    assert_equal :wigwam, b.current_state, 'current state not a symbol'
  end
end
