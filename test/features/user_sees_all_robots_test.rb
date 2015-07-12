require_relative '../test_helper'

class UserSeesAllRobotsTest < FeatureTest

  def test_user_sees_dashboard_welcome_message
    visit('/')
    assert page.has_content?('Welcome to Robot World!')
  end

  def test_user_sees_dashboard_metrics
    visit('/')
    assert page.has_content?('Robots Hired per Year')
  end

  def test_user_can_get_to_new_robot_page
    visit '/'
    assert_equal "/", current_path
    click_link('New Robot')

    assert_equal "/robots/new", current_path
  end

  def test_user_can_create_a_new_robot
    visit('/robots/new')
    fill_in('robot[name]',       :with => 'Jimmy')
    fill_in('robot[city]',       :with => 'Denver')
    fill_in('robot[state]',      :with => 'CO')
    fill_in('robot[avatar]',     :with => 'picture')
    fill_in('robot[birthdate]',  :with => '01/01/2000')
    fill_in('robot[date_hired]', :with => '12/12/2014')
    fill_in('robot[department]', :with => 'IT')

    click_button('Create Robot')

    assert_equal "/robots", current_path
    within ('table') do
      assert page.has_content?('Jimmy')
    end
  end

  def test_user_can_get_to_robot_roster
    visit('/')
    click_link('Roster of Robots')

    assert_equal "/robots", current_path
  end

  def test_user_sees_index_of_robots
    visit('/robots/new')
    fill_in('robot[name]',       :with => 'Jimmy')
    fill_in('robot[city]',       :with => 'Denver')
    fill_in('robot[state]',      :with => 'CO')
    fill_in('robot[avatar]',     :with => 'picture')
    fill_in('robot[birthdate]',  :with => '01/01/2000')
    fill_in('robot[date_hired]', :with => '12/12/2014')
    fill_in('robot[department]', :with => 'IT')

    click_button('Create Robot')

    assert_equal "/robots", current_path
    within ('table') do
      assert page.has_css?('.all_robots')
    end
  end

  def test_user_can_delete_robot
    robot = RobotWorld.create(name:       'Joe',
                               city:       'Pueblo',
                               state:      'CO',
                               avatar:     'picture',
                               birthdate:  '03/04/2002',
                               date_hired: '12/23/2015',
                               department: 'HR')

    visit('/robots')
    assert_equal "/robots", current_path
    within ('table') do
      assert page.has_css?('.all_robots')
    end
    click_button('Delete')
    within ('table') do
      refute page.has_content?('Joe')
    end
  end

  def test_user_can_visit_edit_robot_page
    robot = RobotWorld.create(name:       'Joe',
                               city:       'Pueblo',
                               state:      'CO',
                               avatar:     'picture',
                               birthdate:  '03/04/2002',
                               date_hired: '12/23/2015',
                               department: 'HR')

    visit('/robots')
    assert_equal "/robots", current_path
    within ('table') do
      assert page.has_css?('.all_robots')
    end
    click_link('Edit')
    assert_equal "/robots/#{robot.id}/edit", current_path
  end

  def test_user_can_edit_robot
    robot = RobotWorld.create(name:       'Joe',
                              city:       'Pueblo',
                              state:      'CO',
                              avatar:     'picture',
                              birthdate:  '03/04/2002',
                              date_hired: '12/23/2015',
                              department: 'HR')

    visit('/robots')
    assert_equal "/robots", current_path
    within ('table') do
      assert page.has_css?('.all_robots')
    end
    click_link('Edit')
    assert_equal "/robots/#{robot.id}/edit", current_path

    fill_in('robot[name]',       :with => 'Ron')
    fill_in('robot[city]',       :with => 'Boulder')
    fill_in('robot[department]', :with => 'Security')
    click_button('Update Robot')

    assert page.has_content?('Ron')
  end

  def test_user_goes_to_error_page_on_incorrect_url
    visit('/robots/new')
    fill_in('robot[name]',       :with => 'Jimmy')
    fill_in('robot[city]',       :with => 'Denver')
    fill_in('robot[state]',      :with => 'CO')
    fill_in('robot[avatar]',     :with => 'picture')
    fill_in('robot[birthdate]',  :with => '01/01/2000')
    fill_in('robot[date_hired]', :with => '12/12/2014')
    fill_in('robot[department]', :with => 'IT')
    click_button('Create Robot')

    assert_equal "/robots", current_path

    visit('/tasks/23')

    assert page.has_content?('An Error Occured')

  end
end
