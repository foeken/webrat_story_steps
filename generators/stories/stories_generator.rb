class StoriesGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.directory 'stories'
      m.directory 'stories/examples'
      m.directory 'stories/custom_steps'
      
      m.file      'required_model_attributes.rb','stories/custom_steps/required_model_attributes.rb'
      m.file      'webrat_helper.rb','stories/webrat_helper.rb'
      m.file      'selenium_helper.rb','stories/selenium_helper.rb'
      
      
      m.file      'example_story_spec.rb','stories/examples/example_story_spec.rb'
      m.file      'example_story_spec.rb','stories/examples/example_story_selenium_spec.rb'
      m.file      'example_story.txt','stories/examples/example_story.txt'
      
    end
  end
end
