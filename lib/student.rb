require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade INTEGER
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL

    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO songs (name, album)
      VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.album)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
    end
  end

  def self.create
    student = Student.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE name = ?
      LIMIT 1
    SQL

    DB[:conn].execute(sql, name).map do |row|
    self.new_from_db(row)
    end.first
  end

  def update
    sql = <<-SQL
    UPDATE songs
    SET name = ?, grade = ?
    WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.album, self.id)
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
