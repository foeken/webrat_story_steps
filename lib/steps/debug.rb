steps_for(:debug) do
  
  # Then show the page
  Then(/show the page/) do 
    flunk("A popup with message: #{visible_popup.message} is in the way!") if blocked_by_popup?
    save_and_open_page
  end
  
  # Then show the clients
  Then(/show the (.*)/) do |klass_plural|    
    
    klass_plural = klass_plural.split(' ').join('_') if klass_plural.split(' ').length > 1
    models       = klass_plural.singularize.camelcase.constantize.find(:all)
    
    puts "\n"
    puts "============================================================"
    puts "# Listing all #{klass_plural}"
    puts "============================================================"
    y models
    puts "============================================================"    
  end
  
  # Then show the client with code '111'
  Then(/show the (.*) with (.*) '(.*)'/) do |klass,attribute,value|
    klass = klass.split(' ').join('_') if klass.split(' ').length > 1
    attribute = attribute.split(' ').join('_') if attribute.split(' ').length > 1
    value = Chronic.parse(value).send(@@datetime_attributes[attribute]) if @@datetime_attributes.keys.include?(attribute)
    
    model = klass.camelcase.constantize.send("find_by_#{attribute}", value)
    
    puts "\n"
    puts "============================================================"
    puts "# Listing #{klass}"
    puts "============================================================"
    y model
    puts "============================================================"    
  end
  
end