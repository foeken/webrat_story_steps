def flunk reason
  raise reason
end

# We override these methods since selenium can do a way better job...
def blocked_by_popup?
  browser.selenium.is_confirmation_present || 
  browser.selenium.is_alert_present || 
  browser.selenium.is_prompt_present
end

class StoryDbListener
   
  def scenario_succeeded(story, scenario)
    reset_database
  end
   
  def scenario_pending(story, scenario, error)
    reset_database
  end

  def scenario_failed(story, scenario, error)
    reset_database
  end

  def method_missing(method, *args)
    # no-op
  end
  
  def run_ended
   browser.selenium.stop() rescue nil
  end
  
  def reset_database
    database_name = ActiveRecord::Base.configurations[RAILS_ENV]['database']
    `mysql -u root #{database_name} < selenium_backup.sql`
  end  
  
end

class Spec::Story::Runner::ScenarioRunner
  def initialize
    @listeners = []
  end
end


# This allows assert_select to work...
class RailsStory < ActionController::IntegrationTest
  def response_from_page_or_rjs    
    HTML::Document.new(browser.body).root
  end
end


# This is how you register your listener
Spec::Story::Runner.register_listener(StoryDbListener.new)