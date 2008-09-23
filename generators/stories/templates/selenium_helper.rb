ENV["RAILS_ENV"] = "test"

puts "INSTRUCTIONS: 3 ITEMS REQUIRED"
puts "0.) Make sure you have a properly migrated test database and FireFox installed (!)"
puts "    If you want Safari. Manually configure the proxy to localhost:4444 ... It's wonky under OSX"
puts "1.) Run: rake selenium:start"
puts "2.) Then run this file!"

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require File.expand_path(File.dirname(__FILE__) + "/../vendor/plugins/webrat_story_steps/lib/common")
require File.expand_path(File.dirname(__FILE__) + "/../vendor/plugins/webrat_story_steps/lib/selenium")
require "webrat/selenium"

include WebratStorySteps::Site

# Make a dump of the db before we begin!
task = `rake -D db:dump`
unless task.gsub(/\(in .*\)\n/, '').empty?
  database_name = ActiveRecord::Base.configurations[RAILS_ENV]['database']
  `rake db:dump DATABASE=#{database_name} FILE=selenium_backup.sql`
end

Dir[File.expand_path("#{File.dirname(__FILE__)}/custom_steps/*.rb")].uniq.each do |file|
  require file
end

if !@selenium_browser
  the_browser = 'firefox' # could be 'chrome' or 'safari'
  rc_host     = 'localhost'
  rc_port     = '4444'
  target      = 'http://localhost:3800'
  timeout     = 10000

  @selenium_browser = Selenium::SeleniumDriver.new(
    rc_host, rc_port, "*#{the_browser}", target, timeout
  )

  @selenium_browser.start
  
  self.set_browser( Webrat::SeleniumSession.new(@selenium_browser) )
  
  browser.visits target
end