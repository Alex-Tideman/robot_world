
ENV['ROBOT_WORLD_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'minitest/autorun'
require 'capybara'
require 'tilt/erb'


class Minitest::Test
  def teardown
    RobotWorld.delete_all
  end
end

Capybara.app = RobotWorldApp

class FeatureTest < Minitest::Test
  include Capybara::DSL
end