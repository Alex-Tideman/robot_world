require 'yaml/store'
require 'date'
require 'bigdecimal'
require_relative 'robot'

class RobotWorld
  def self.database
    @database ||= YAML::Store.new("db/robot_world")
  end

  def self.create(robot)
    database.transaction do
      database['robots'] ||= []
      database['total'] ||= 0
      database['total'] += 1
      database['robots'] << { "id" => database['total'], "name" => robot[:name],
                              "city" => robot[:city], "state" => robot[:state],
                              "avatar" => robot[:avatar], "birthdate" => robot[:birthdate],
                              "date_hired" => robot[:date_hired], "department" => robot[:department]}
    end
  end

  def self.raw_robots
    database.transaction do
      database['robots'] || []
    end
  end

  def self.all
    raw_robots.map { |data| Robot.new(data)}
  end

  def self.raw_robot(id)
    raw_robots.find { |robot| robot["id"] == id}
  end

  def self.find(id)
    Robot.new(raw_robot(id))
  end

  def self.update(id, robot)
    database.transaction do
      target = database['robots'].find { |data| data["id"] == id }
      target["name"]       = robot[:name]
      target["city"]       = robot[:city]
      target["state"]      = robot[:state]
      target["avatar"]     = robot[:avatar]
      target["birthdate"]  = robot[:birthdate]
      target["date_hired"] = robot[:date_hired]
      target["department"] = robot[:department]
    end
  end

  def self.delete(id)
    database.transaction do
      database['robots'].delete_if { |robot| robot["id"] == id}
    end
  end

  def self.average_robot_age
    count = 0
    database.transaction do
      ages = database['robots'].map do |robot|
        count += 1
        ((Date.today - Date.strptime(robot["birthdate"],'%m/%d/%Y')).to_i) / 365.0
      end
      (ages.reduce(:+) / count).round(2)
    end
  end

  def self.robots_hired_per_year
    per_year = Hash.new { |hsh, key| hsh[key] = 0}
    database.transaction do
        database['robots'].map do |robot|
          year = Date.strptime(robot["date_hired"],'%m/%d/%Y').year
          per_year[year] += 1
        end
      per_year
      end
  end

  def self.robots_hired_per_department
    per_year = Hash.new { |hsh, key| hsh[key] = 0}
    database.transaction do
      database['robots'].map do |robot|
        department = robot["department"]
        per_year[department] += 1
      end
      per_year
    end
  end

  def self.robots_hired_per_city
    per_year = Hash.new { |hsh, key| hsh[key] = 0}
    database.transaction do
      database['robots'].map do |robot|
        city = robot["city"]
        per_year[city] += 1
      end
      per_year
    end
  end

  def self.robots_hired_per_state
    per_year = Hash.new { |hsh, key| hsh[key] = 0}
    database.transaction do
      database['robots'].map do |robot|
        state = robot["state"]
        per_year[state] += 1
      end
      per_year
    end
  end

end

