steps_for(:models) do
  
  @previous_model = nil
  
  # Given a user with username 'Dummy' exists
  Given(/(a|an) (.*) with (.*) '(.*)' exists/) do |a_or_an,klass,attribute,value|    
  
    klass = convert_klass(klass)
    attribute = convert_attribute(attribute)
    
    value = convert_attribute_value(attribute,value)
    
    model = klass.camelcase.constantize.send(:new, get_required_attributes_for(klass))
    model.send("#{attribute}=".to_sym,value)
    model.save!
    
    @previous_model = model
  end
  
  # Given there are no units in the system
  # Given there are no units and employees in the system
  # Given there are no units or employees in the system
  # Given there are no units, employees or clients in the system
  Given(/there are no (.*) in the system/) do |words|
    
    words = words.gsub(' and ',',')
    words = words.gsub(' or ',',')
    words = words.split(',').map(&:strip)
    
    words.each do |klass|
      klass = convert_klass(klass)
      klass = klass.singularize
      klass.camelcase.constantize.delete_all
    end
    
  end
    
  # Given the user with username 'Dummy' has a responsibility for the role with name 'Planner'
  Given(/the (.*) with (.*) '(.*)' has a (.*) for the (.*) with (.*) '(.*)'/) do |klass,attribute,value,relation,related_klass,attribute_2,value_2|
    
    relation      = convert_klass(relation)
    klass         = convert_klass(klass)
    related_klass = convert_klass(related_klass)
    
    attribute = convert_attribute(attribute)
    attribute_2 = convert_attribute(attribute_2)
    
    value = convert_attribute_value(attribute,value)
    value_2 = convert_attribute_value(attribute_2,value_2)
    
    model  = klass.camelcase.constantize.send("find_by_#{attribute}", value)
    model2 = related_klass.camelcase.constantize.send("find_by_#{attribute_2}", value_2)
    
    flunk("Cannot find the #{klass} with #{attribute} '#{value}'") if !model
    flunk("Cannot find the #{related_klass} with #{attribute_2} '#{value_2}'") if !model2
    
    @previous_model = model.send(relation.downcase.pluralize.to_sym).create!( 
                          ( get_required_attributes_for(relation) || {} ).merge( related_klass.downcase.to_sym => model2 ) )            
  end
  
  # Given it has a responsibility for the role with name 'Planner'
  Given(/(it|he|she) has a (.*) for the (.*) with (.*) '(.*)'/) do |gender,relation,related_klass,attribute_2,value_2|    
    
    relation      = convert_klass(relation)
    related_klass = convert_klass(related_klass)
    attribute_2   = convert_attribute(attribute_2)
    
    value_2 = convert_attribute_value(attribute_2,value_2)
    
    model  = @previous_model
    model2 = related_klass.camelcase.constantize.send("find_by_#{attribute_2}", value_2)
    
    flunk("Cannot find referenced model") if !model
    flunk("Cannot find the #{related_klass} with #{attribute_2} '#{value_2}'") if !model2
    
    model.send(relation.downcase.pluralize.to_sym).create!( 
        ( get_required_attributes_for(relation) || {} ).merge( related_klass.downcase.to_sym => model2 ) )            
  end
      
  # Given the user with name 'Andre' belongs to a person with last name 'Foeken'
  Given(/the (.*) with (.*) '(.*)' belongs to a (.*) with (.*) '(.*)'/) do |klass,attribute,value,klass2,attribute2,value2|
    klass = convert_klass(klass)
    attribute = convert_attribute(attribute)
    
    klass2 = convert_klass(klass2)
    attribute2 = convert_attribute(attribute2)
    
    value = convert_attribute_value(attribute,value)
    value2 = convert_attribute_value(attribute2,value2)
    
    model  = klass.camelcase.constantize.send("find_by_#{attribute}", value)
    model2 = klass2.camelcase.constantize.send("find_by_#{attribute2}", value2)
    
    flunk("Cannot find the #{klass} with #{attribute} '#{value}'") if !model
    flunk("Cannot find the #{klass2} with #{attribute2} '#{value2}'") if !model2
    
    model.send((klass2+'=').to_sym,model2)
    model.save!
    
    @previous_model = model
  end
  
  # Given it belongs to a person with last name 'Foeken'
  Given(/(he|she|it) belongs to (a|the) (.*) with (.*) '(.*)'/) do |gender,a_or_the,klass,attribute,value|
    klass = convert_klass(klass)
    attribute = convert_attribute(attribute)
    
    value = convert_attribute_value(attribute,value)
    
    model = klass.camelcase.constantize.send("find_by_#{attribute}", value)
    
    flunk("Cannot find the #{klass} with #{attribute} '#{value}'") if !model
    
    @previous_model.send((klass+'=').to_sym,model)
    @previous_model.save!
  end
  
  
  # Given the user with username 'Dummy' has password '123'
  Given(/the (.*) with (.*) '(.*)' (has the|has an|has a|has|is) (.*) '(.*)'/) do |klass,attribute,value,a,other_attribute,other_value|
    klass = convert_klass(klass)
    
    attribute = convert_attribute(attribute)
    other_attribute = convert_attribute(other_attribute)
    
    value = convert_attribute_value(attribute,value)
    other_value = convert_attribute_value(other_attribute,other_value)
     
    model = klass.camelcase.constantize.send("find_by_#{attribute}", value)
    
    flunk("Cannot find the #{klass} with #{attribute} '#{value}'") if !model
    
    model.send("#{other_attribute}=".to_sym,other_value)
    model.save!
    @previous_model = model
  end
  
  # Given it has password '123'
  # Given it has a password '123'
  # Given it has an hour type id '123'
  # Given it has the code '123'
  Given(/(it|he|she) (has the|has an|has a|has|is) (.*) '(.*)'/) do |gender,a,other_attribute,other_value|
    other_attribute = convert_attribute(other_attribute)            
    other_value = convert_attribute_value(other_attribute,other_value)
    
    @previous_model.send("#{other_attribute}=".to_sym,other_value)
    @previous_model.save!
  end
      
  # Then a user with username 'Dummy' should exist
  Then("a $klass with $attribute '$value' should exist") do |klass,attribute,value|
    
    flunk("A popup with message: '#{visible_popup.message}' is in the way!") if blocked_by_popup?
    
    klass = convert_klass(klass)
    attribute = convert_attribute(attribute)
    
    value = convert_attribute_value(attribute,value)
        
    model = klass.camelcase.constantize.send("find_by_#{attribute}", value)    
    model.should_not be_nil    
    @previous_model = model
  end
      
  # Then the role with name 'Dummy' should (not) have a right with controller 'Employees'
  # Then the role with name 'Dummy' should (not) belong to a right with controller 'Employees'
  Then(/the (.*) with (.*) '(.*)' should (belong to|have|not belong to|not have) a (.*) with (.*) '(.*)'/) do |klass_1,attribute_1,value_1,have_or_belongs,klass_2,attribute_2,value_2|    
    
    klass_1     = convert_klass(klass_1)
    attribute_1 = convert_attribute(attribute_1)
    value_1     = convert_attribute_value(attribute_1,value_1)
    object_1    = klass_1.camelcase.constantize.send("find_by_#{attribute_1}", value_1)
    
    @previous_model = object_1
    
    klass_2     = convert_klass(klass_2)
    attribute_2 = convert_attribute(attribute_2)    
    value_2     = convert_attribute_value(attribute_2,value_2)
    
    if have_or_belongs == "belong to"
      
      object_2 = object_1.send(klass_2.downcase.to_sym)
      object_2.send(attribute_2.to_sym).should eql(value_2)   
         
    elsif have_or_belongs == "have"
      
      candidates = object_1.send(klass_2.downcase.pluralize.to_sym)
      
      found = false
      candidates.each do |candidate|
        if candidate.send(attribute_2.to_sym) == value_2
          found = true
          break
        end
      end
      
      flunk("Did not find #{klass_2} with #{attribute_2} '#{value_2}' in given #{object_1.class.to_s}") if !found

    elsif have_or_belongs == "not belong to"
      
      object_2 = object_1.send(klass_2.downcase.to_sym)
      object_2.send(attribute_2.to_sym).should_not eql(value_2)
      
    elsif have_or_belongs == "not have"
      
      candidates = object_1.send(klass_2.downcase.pluralize.to_sym)
      
      found = false
      candidates.each do |candidate|
        if candidate.send(attribute_2.to_sym) == value_2
          found = true
          break
        end
      end
      
      flunk("Found #{klass_2} with #{attribute_2} '#{value_2}' in given #{object_1.class.to_s}. This should not have happened!") if found
      
    end
    
  end
  
  # Then it should (not) have a right with controller 'Employees'
  # Then it should (not) belong to a right with controller 'Employees'
  Then(/it should (belong to|have|not belong to|not have) a (.*) with (.*) '(.*)'/) do |have_or_belongs,klass_2,attribute_2,value_2|    
        
    object_1 = @previous_model
    
    klass_2     = convert_klass(klass_2)
    attribute_2 = convert_attribute(attribute_2)    
    value_2     = convert_attribute_value(attribute_2,value_2)
    
    if have_or_belongs == "belong to"
      
      object_2 = object_1.send(klass_2.downcase.to_sym)
      object_2.send(attribute_2.to_sym).should eql(value_2)   
         
    elsif have_or_belongs == "have"
      
      candidates = object_1.send(klass_2.downcase.pluralize.to_sym)
      
      found = false
      candidates.each do |candidate|
        if candidate.send(attribute_2.to_sym) == value_2
          found = true
          break
        end
      end
      
      flunk("Did not find #{klass_2} with #{attribute_2} '#{value_2}' in given #{object_1.class.to_s}") if !found

    elsif have_or_belongs == "not belong to"
      
      object_2 = object_1.send(klass_2.downcase.to_sym)
      object_2.send(attribute_2.to_sym).should_not eql(value_2)
      
    elsif have_or_belongs == "not have"
      
      candidates = object_1.send(klass_2.downcase.pluralize.to_sym)
      
      found = false
      candidates.each do |candidate|
        if candidate.send(attribute_2.to_sym) == value_2
          found = true
          break
        end
      end
      
      flunk("Found #{klass_2} with #{attribute_2} '#{value_2}' in given #{object_1.class.to_s}. This should not have happened!") if found
      
    end
    
  end
  
  
  # Then the user with username 'Dummy' should not be planner
  # Then the user with username 'Dummy' should be planner       => User.planner?
  Then(/the (.*) with (.*) '(.*)' should (be|not be) (.*)/) do |klass,attribute,value,be_or_not_be,method|    
    
    flunk("A popup with message: '#{visible_popup.message}' is in the way!") if blocked_by_popup?
    
    begin      
      klass = convert_klass(klass)
      attribute = convert_attribute(attribute)      
      value = convert_attribute_value(attribute,value)      
      object = klass.camelcase.constantize.send("find_by_#{attribute}", value)
      
      @previous_model = object
      
      if be_or_not_be == "be"
        object.send("#{method}?".to_sym).should be_true
      else
        object.send("#{method}?".to_sym).should be_false
      end
    rescue
      flunk("#{klass} should #{be_or_not_be} #{method}")
    end    
  end
    
  # Then it should not be planner
  # Then it should be planner       => User.planner?
  Then(/it should (be|not be) (.*)/) do |be_or_not_be,method|    
    
    flunk("A popup with message: '#{visible_popup.message}' is in the way!") if blocked_by_popup?
    
    begin      
      klass = convert_klass(klass)
      attribute = convert_attribute(attribute)      
      value = convert_attribute_value(attribute,value)      
      object = klass.camelcase.constantize.send("find_by_#{attribute}", value)
      
      object = @previous_model
      
      if be_or_not_be == "be"
        object.send("#{method}?".to_sym).should be_true
      else
        object.send("#{method}?".to_sym).should be_false
      end
    rescue
      flunk("#{klass} should #{be_or_not_be} #{method}")
    end
     
  end
  
          
end