# Set test environment. Include environment and webrat story steps plugin
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require File.expand_path(File.dirname(__FILE__) + "/../vendor/plugins/webrat_story_steps/lib/common")

include WebratStorySteps::Site

Dir[File.expand_path("#{File.dirname(__FILE__)}/custom_steps/*.rb")].uniq.each do |file|
  require file
end