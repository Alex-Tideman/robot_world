require 'sequel'
require 'sqlite3'
require 'date'
require 'bigdecimal'

class RobotWorld

  def self.create(robot)
    begin
      dataset.insert(:name       => robot[:name],
                     :city       => robot[:city],
                     :state      => robot[:state],
                     :avatar     => robot[:avatar],
                     :birthdate  => robot[:birthdate],
                     :date_hired => robot[:date_hired],
                     :department => robot[:department])
    rescue
      return false
    end

    Robot.new(dataset.to_a.last)
  end

  def self.database
    if ENV['ROBOT_WORLD_ENV'] == 'test'
      @database ||= Sequel.sqlite('db/robot_world_test.sqlite3')
    else
      @database ||= Sequel.sqlite('db/robot_world_development.sqlite3')
    end
  end

  def self.all
    dataset.to_a.map do |data|
      Robot.new(data)
    end
  end

  def self.find(id)
    Robot.new(dataset.where(id: id).to_a.first)
  end

  def self.update(id, robot)
    dataset.where(id: id).update(robot)
  end

  def self.delete(id)
    dataset.where(id: id).delete
  end

  def self.delete_all
    dataset.delete
  end

  def self.dataset
    database.from(:robots)
  end

  def self.average_robot_age
    if all.empty?
      "No Robots"
    else
      count = 0
      database.transaction do
        ages = database[:robots].map do |robot|
          count += 1
          ((Date.today - Date.strptime(robot[:birthdate],'%m/%d/%Y')).to_i) / 365.0
        end
        (ages.reduce(:+) / count).round(2)
      end
    end
  end

  def self.robots_hired_per_year
    per_year = Hash.new { |hsh, key| hsh[key] = 0}
    database.transaction do
        database[:robots].map do |robot|
          year = Date.strptime(robot[:date_hired],'%m/%d/%Y').year
          per_year[year] += 1
        end
      per_year
      end
  end

  def self.robots_hired_per_department
    per_year = Hash.new { |hsh, key| hsh[key] = 0}
    database.transaction do
      database[:robots].map do |robot|
        department = robot[:department]
        per_year[department] += 1
      end
      per_year
    end
  end

  def self.robots_hired_per_city
    per_year = Hash.new { |hsh, key| hsh[key] = 0}
    database.transaction do
      database[:robots].map do |robot|
        city = robot[:city]
        per_year[city] += 1
      end
      per_year
    end
  end

  def self.robots_hired_per_state
    per_year = Hash.new { |hsh, key| hsh[key] = 0}
    database.transaction do
      database[:robots].map do |robot|
        state = robot[:state]
        per_year[state] += 1
      end
      per_year
    end
  end

end

