# Include dependencies
require 'spec/story'
require 'spec/rails/story_adapter'
require 'webrat'
require 'chronic'

# Include all the basic steps
require 'steps/authorization.rb'
require 'steps/debug.rb'
require 'steps/forms.rb'
require 'steps/inspection.rb'
require 'steps/models.rb'
require 'steps/navigation.rb'

module WebratStorySteps
  module Site
    
    #
    # NASTYNESS
    #
    
    # I know this part is ugly, will need to be refactored. At least the uglyness is focussed on this point!    
    @@datetime_attributes = {}
    @@required_attributes = {}
    @@browser             = nil
        
    # Set the attributes that should be handled as date time parsable
    def set_datetime_attributes hash
      @@datetime_attributes = hash
    end
    
    # Gets the datetime attributes
    def get_datetime_attributes
      return @@datetime_attributes
    end
    
    # Gets the required attributes for the given class
    def get_required_attributes_for klass
      @@required_attributes[klass.downcase.to_sym]
    end
    
    # Sets the required attributes for the given class
    def set_required_attributes_for klass, attributes
      @@required_attributes[klass.downcase.to_sym] = attributes
    end
    
    def set_browser browser
      @@browser = browser
    end
    
    def browser
      @@browser || self
    end
    
    def selenium?
      defined?(Selenium)
    end

    def body
      if selenium?
        response_body
      else
        response.body
      end
    end
    
    def popup_message
      if selenium?
        browser.selenium.get_confirmation
      else
        visible_popup.message
      end
    end
    
    #
    # NATURAL LANGUAGE CONVERSIONS
    #
          
    # This method converts a natural language class to a ruby class
    def convert_klass klass
      return klass.split(' ').join('_') if klass.split(' ').length > 1
      return klass
    end
    
    # This method converts a natural language attribute to a ruby attribute
    def convert_attribute attribute
      return attribute.split(' ').join('_') if attribute.split(' ').length > 1
      return attribute
    end
    
    # This method converts a natural language attribute value to a db value (like a date)
    def convert_attribute_value attribute, value
      return Chronic.parse(value).send(get_datetime_attributes[attribute]) if get_datetime_attributes.keys.include?(attribute)
      return value
    end
    
    def login username, password       
      if selenium?
    	browser_object = browser
      else
    	browser_object = self 
      end      
      
      browser_object.visits "/login"
      browser_object.fills_in "username", :with => username      
      browser_object.fills_in "password", :with => password
      browser_object.clicks_button      
       
      if !selenium?
        begin      
          body.should match(/1.*/)
          visits '/'
        rescue
          flunk "Cannot login using these credentials. Perhaps reference user is not correct?"
        end
      end              
    end
           
    def logout
      if selenium?
        browser.visits '/login/destroy'
      else
        visits '/login/destroy'
      end
    end
            
  end
    
end


