ENV["RAILS_ENV"] = "test"

puts "MANUAL: 3 ITEMS REQUIRED"
puts "0.) Make sure you have a properly migrated test database and FireFox installed (!)"
puts "    If you want Safari. Manually configure the proxy to localhost:4444 ... It's wonky under OSX"
puts "1.) Run a server like this: ./script/server -e test"
puts "2.) Run: rake selenium:start"
puts "3.) Then run this file!"

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require File.expand_path(File.dirname(__FILE__) + "/../vendor/plugins/webrat_story_steps/lib/common")
require File.expand_path(File.dirname(__FILE__) + "/../vendor/plugins/webrat_story_steps/lib/selenium")
require "webrat/selenium"

include WebratStorySteps::Site

# Make a dump of the db before we begin!
database_name = ActiveRecord::Base.configurations[RAILS_ENV]['database']
`rake db:dump DATABASE=#{database_name} FILE=selenium_backup.sql`

Dir[File.expand_path("#{File.dirname(__FILE__)}/custom_steps/*.rb")].uniq.each do |file|
  require file
end

if !@selenium_browser
  the_browser = SeleniumSpecr::SeleniumRcServer.browser
  host        = SeleniumSpecr::SeleniumRcServer.host
  rc_port     = SeleniumSpecr::SeleniumRcServer.port
  target      = SeleniumSpecr::ApplicationServer.url
  timeout     = 10000

  @selenium_browser = Selenium::SeleniumDriver.new(
    host, rc_port, "*#{the_browser}", target, timeout
  )

  @selenium_browser.start
  
  self.set_browser( Webrat::SeleniumSession.new(@selenium_browser) )
  
  browser.visits target
end