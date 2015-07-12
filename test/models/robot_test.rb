require_relative '../test_helper'

class TaskTest < Minitest::Test
  def test_assigns_attributes_correctly
    robot = Robot.new({   :id           =>  1,
                          :name         => "a name",
                          :city         => "a city",
                          :state        => "a state",
                          :avatar       => "a avatar",
                          :birthdate    => "05/05/2005",
                          :date_hired   => "10/10/2010",
                          :deparment    => "a department"  })
    assert_equal "a city", robot.city
    assert_equal "10/10/2010", robot.date_hired
    assert_equal 1, robot.id
  end
end

