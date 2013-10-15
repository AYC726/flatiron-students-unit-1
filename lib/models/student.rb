
require 'nokogiri'
require 'open-uri'
require 'sqlite3'
require 'pry'
 
class Student
  attr_accessor :name, :twitter, :linkedin, :github, :blog
  attr_reader :id
 
  @@students = []
 
  @@db = SQLite3::Database.new('students_2test.db')
 
  def new_record?
    !saved?
  end
 
  def saved?
    @saved
  end

  
  def initialize(id, name, twitter, linkedin, github, blog)
    @name = name
    @twitter = twitter
    @linkedin = linkedin
    @github = github
    @blog = blog
    @id = id
    create_table
    insert
    # if id.nil?
    #   if @@students.count == 0
    #     @id = 1
    #   else
    #     @id = @@students.max_by { |s| s.id }.id + 1
    #   end
    # end
    @@students << self
    @saved = !id.nil?
  end


  def create_table
    cmd = "CREATE TABLE IF NOT EXISTS students (
      id INTEGER,
      name TEXT,
      twitter TEXT,
      linkedin TEXT,
      github TEXT,
      blog TEXT);" 
    @@db.execute(cmd);
    #id INTEGER PRIMARY KEY AUTOINCREMENT,
  end

  def get_id
    cmd = "SELECT MAX(id) from STUDENTS"
    @id = @@db.execute(cmd).flatten[0]
  end
 
  def insert
    cmd = "INSERT INTO STUDENTS (id, name, twitter, linkedin, github, blog) VALUES (?, ?, ?, ?, ?, ?)"
    @@db.execute(cmd, self.id, self.name, self.twitter, self.linkedin, self.github, self.blog)
    get_id
    @saved = true
  end
 
  def update
    cmd = "UPDATE STUDENTS set name = ? where id = ?"
    @@db.execute(cmd, self.name, self.id)
    @saved = true
  end
 
  def save
    if @saved
      update
    else
      insert
    end
  end
 
  def self.reset_all
    @@students.clear
  end
 
  def self.all
    @@students
  end
 
  def self.find_by_name(name)
    @@students.select { |s| s.name == name }
  end
 
  def self.find(id)
    Student.load(id)
  end
 
  def self.delete(id)
    @@students.reject! { |s| s.id == id}
  end
 
  def self.load(id)
    cmd = "SELECT * FROM STUDENTS WHERE ID = ?"
    result = @@db.execute(cmd, id)
    Student.new_with_row(result.flatten)
  end
 
#first select data from database
#

  def self.new_with_row(row)
    s = Student.new(row[0], row[1], row[2], row[3], row[4], row[5])
    puts s.id
    puts s.name
    puts s.github
    puts s.linkedin
    puts s.twitter
    puts s.blog
  end
end


 
# class Student

#   @@db = SQLite3::Database.new("student1.db")
#   #TODO .....COME BACK TO THIS, figure out correct path  to save in db folder

#   attr_accessor :name, :twitter, :linkedin, :facebook, :website
#   @@students = []

#   def initialize(name=nil, twitter=nil, linkedin=nil, facebook=nil, website=nil)
#     @@students << self
#     @name = name
#     @twitter = twitter
#     @linkedin = linkedin
#     @facebook = facebook
#     @website = website
#   end

#   def self.reset_all
#     @@students.clear
#   end

#   def self.all
#     @@students
#   end

#   def self.find_by_name(name)
#     @@students.select do |x|
#       x.name == name
#     end
#   end

# end

