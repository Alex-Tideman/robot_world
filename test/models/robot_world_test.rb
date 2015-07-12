require_relative '../test_helper'

class RobotWorldTest < Minitest::Test

  def test_it_creates_a_robot
    make_robots(1)
    robot = RobotWorld.find(RobotWorld.all.first.id)
    assert_equal "a name",   robot.name
    assert_equal "a avatar", robot.avatar
    assert_equal RobotWorld.all.first.id, robot.id
  end

  def test_it_gets_all_robots
    make_robots(6)
    robots = RobotWorld.all
    assert_equal 12, robots.count
  end

  def test_it_finds_a_robot
    make_robots(2)
    robot = RobotWorld.find(RobotWorld.all.last.id)
    assert_equal "12/12/2012", robot.date_hired
  end

  def test_it_updates_a_robot
    make_robots(2)
    RobotWorld.update(RobotWorld.all.last.id, { :name => "Jimmy" } )
    robot = RobotWorld.find(RobotWorld.all.last.id)
    assert_equal "Jimmy", robot.name
  end

  def test_it_destroys_a_robot
    make_robots(4)
    RobotWorld.delete(RobotWorld.all.first.id)
    robots = RobotWorld.all
    assert_equal 7, robots.count
  end

  def make_robots(n)
    n.times do
      RobotWorld.create ({  :name         => "a name",
                            :city         => "a city",
                            :state        => "a state",
                            :avatar       => "a avatar",
                            :birthdate    => "05/05/2005",
                            :date_hired   => "10/10/2010",
                            :department   => "a department"  })
      RobotWorld.create ({  :name         => "a second name",
                            :city         => "a second city",
                            :state        => "a second state",
                            :avatar       => "a second avatar",
                            :birthdate    => "03/05/2000",
                            :date_hired   => "12/12/2012",
                            :department   => "another department"  })
    end
  end
end