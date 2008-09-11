require File.join(File.dirname(__FILE__) + "/../", *%w[selenium_helper])

with_steps_for :debug, :authorization, :navigation, :forms, :models, :inspection do
  run File.dirname(__FILE__) + '/example_story.txt', :type => RailsStory
end