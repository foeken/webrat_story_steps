steps_for(:forms) do
  
  # When he fills the 'Name' field with 'Andre'
  # When he fills the first 'Name' field with 'Andre'
  When(/(he|she) fills (the|the first|the second|the third) '(.*)' field with '(.*)'/) do |gender,order,field,value|

    field_name = nil
    
    case order
      when "the", "the first"
        counter = 0
      when "the second"        
        counter = 1
      when "the third"        
        counter = 2
    end
    
    begin
      assert_select("label", field) do |elements|
        elements.each do |element|
          if counter == 0
            field_name = element["for"]
            break
          end
          counter -= 1
        end
      end
    rescue
    end
    
    # fallback when using 'the' and the id of a field...
    if !field_name && order == "the"
      field_name = field
    end
            
    fills_in field_name, :with => value
  end

  # When he fills the 'End of care' date field with 'tomorrow'
  When(/(he|she) fills (the|the first|the second|the third) '(.*)' date field with '(.*)'/) do |gender,order,field,value|    
    value = Chronic.parse(value)  
    
    field_name = nil
    
    case order
      when "the", "the first"
        counter = 0
      when "the second"        
        counter = 1
      when "the third"        
        counter = 2
    end
    
    begin
      assert_select("label", field) do |elements|
        elements.each do |element|
          if counter == 0
            field_name = element["for"]
            break
          end
          counter -= 1
        end
      end
    rescue    
    end
      
    if !field_name
      flunk("Cannot find the field you meant...")
    end

    fills_in "#{field_name}_3i", :with => value.day
    fills_in "#{field_name}_2i", :with => value.month
    fills_in "#{field_name}_1i", :with => value.year
  end
  
  # When he clicks the button
  When(/(he|she) clicks the button/) do |gender|
    clicks_button
  end
  
  # When he selects 'Partner name'
  When(/(he|she) selects '(.*)'/) do |gender,value|
    selects(value)      
  end
  
  # When he picks 'Partner name' (for both select/radio fields)
  When(/(he|she) picks '(.*)'/) do |gender,value|
    begin
      chooses(value)
    rescue
      selects(value)
    end
  end
  
  # When he chooses 'Male'
  When(/(he|she) chooses '(.*)'/) do |gender,value|
    chooses(value)
  end
  
  # When he (un)checks 'Enabled'
  When(/(he|she) (checks|unchecks) '(.*)'/) do |gender,checks_or_unchecks,value|
    if checks_or_unchecks == "checks"
      checks(value)
    else
      unchecks(value)
    end
  end
        
end