require 'pry'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'

require_relative './student'

class StudentScraper
  attr_accessor :url, :student

  @@student_profiles_array = []

  def initialize(url)
    @url = url  
  end

  def call
    student_index_page = Nokogiri::HTML(open(@url))
    self.scrape_index(student_index_page)
  end

  def scrape_index(student_index_page)
    student_links = 
    student_index_page.css("div.blog-title div.big-comment h3 a").collect do |link|
      "http://students.flatironschool.com/#{link['href']}"
    end
    
    self.scrape_pages(student_links)

  end

  def scrape_pages(student_links)

    student_profiles_array = []
    

    student_links.each_with_index do |student, i|
      # begin

      student_profile = Nokogiri::HTML(open(student))
      
      id = "#{i+1}"
      name = student_profile.css("h4.ib_main_header").text
      quote = student_profile.css("div#testimonial-slider").text.gsub("\n","").strip!
      biography = student_profile.css("div.services p")[0].text.gsub("\n","").strip!
      social_links =  student_profile.css('div.social-icons a')
      twitter =  student_profile.css('div.social-icons a')[0].first[1]
      linkedin = student_profile.css('div.social-icons a')[1].first[1]
      github = student_profile.css('div.social-icons a')[2].first[1]
      if student_profile.css('div.social-icons a')[3] == nil
        blog = "no blog"
      else 
        blog = student_profile.css('div.social-icons a')[3].first[1]
      end

      student_profiles_hash = {}
      student_profiles_hash[name] = {}
      student_profiles_hash[name][:quote] = quote
      student_profiles_hash[name][:biography] = biography
      student_profiles_hash[name][:social_links] = {}
      
      student_profiles_hash[name][:social_links][:twitter] = twitter
      student_profiles_hash[name][:social_links][:linkedin] = linkedin
      student_profiles_hash[name][:social_links][:github] = github
      student_profiles_hash[name][:social_links][:blog] = blog

      Student.new(id, name, student_profiles_hash[name][:social_links][:twitter], student_profiles_hash[name][:social_links][:linkedin], student_profiles_hash[name][:social_links][:github], student_profiles_hash[name][:social_links][:blog]) 

      # rescue
        # puts "#{student} just created an error"
      # end
    end
  end

end

binding.pry

url = "http://students.flatironschool.com"
student_scrape = StudentScraper.new(url)
student_hashes = student_scrape.call

