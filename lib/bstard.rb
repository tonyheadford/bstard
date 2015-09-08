require 'bstard/version'
require 'bstard/fsm'
require 'bstard/errors'

module Bstard
  def self.define
    fsm = Fsm.new
    yield fsm if block_given?
    fsm
  end
end

