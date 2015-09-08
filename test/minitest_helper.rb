$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'minitest/autorun'
require 'minitest/reporters'
require 'bstard'

Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new, ENV, Minitest.backtrace_filter)

