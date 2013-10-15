require 'pry'
require 'nokogiri'
require 'open-uri'
require_relative './student'
require_relative './student_scrape'

class  CLIStudent
  attr_accessor :students, :name

  APPROVED_COMMANDS = [:browse, :help, :exit]

  def initialize(students)
    @students = Student.all.collect{|student| student}
    @name = name
    @on = true
  end

  def call
    system('clear')
    while self.on?
      self.help
    end
  end

  def on?
    @on
  end

  def help
    puts "This is the help command. Please select browse, help, exit, or show. \n"
    self.command_request
  end

  def command_request
    self.command(gets.strip)
  end

  def command(input)
    if APPROVED_COMMANDS.include?(input.strip.downcase.to_sym)
      self.send(input)
    elsif input.start_with?("show")
      name = input.split("show").last.strip
      self.show(name)
    else
      puts "invalid command \n"
      puts
    end
  end

  def browse
    self.students.each_with_index do |student, i|
      puts "#{i+1}. #{student.name}"
    end
  end

  def show(name)

    if name.to_i > 0

      puts
      puts "\t Name: #{students[name.to_i-1].name}"
      puts "\t Twitter: #{students[name.to_i-1].twitter}"
      puts "\t Github: #{students[name.to_i-1].github}"
      puts "\t Linkedin: #{students[name.to_i-1].linkedin}"
      puts "\t Blog: #{students[name.to_i-1].blog}"
      puts

    else 
      
      matching_student = Student.find_by_name(name)
      student_entity = matching_student.first
      puts
      puts "\t Name: #{student_entity.name}"
      puts "\t Twitter: #{student_entity.twitter}"
      puts "\t Github: #{student_entity.github}"
      puts "\t Linkedin: #{student_entity.linkedin}"
      puts "\t Blog: #{student_entity.blog}"
      puts
    
    end

  end

  def exit
    puts "Hasta la Vista, baby"
    @on = false
  end

end

binding.pry

students = Student.all
cli_browser = CLIStudent.new(students) 
cli_browser.call