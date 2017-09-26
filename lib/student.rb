require_relative "../config/environment.rb"
require "pry"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id

  end

  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS students (id INTEGER PRIMARY KEY, name TEXT, grade TEXT);"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def save

    if self.id == nil
      sql = "INSERT INTO students (name, grade) VALUES(?, ?)"
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    else
      binding.pry
      self.update
    end
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
      new_student = self.new(row[1], row[2], row[0])
      new_student
  end

  def self.create(name, grade)
    new_student = Student.new(name, grade)
    new_student.save
    new_student
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    DB[:conn].execute(sql, name).each do |row|
      return self.new_from_db(row)
    end

  end

  def update
    sql = "UPDATE students SET name = ? , grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
    binding.pry
  end

end
