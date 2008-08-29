steps_for(:navigation) do

  # When he clicks the 'Employees' link
  When(/(he|she) clicks the '(.*)' link/) do |gender,link|
    clicks_link(link)
  end
  
  # When he clicks next week
  # When she clicks previous week
  When(/(he|she) clicks (next|previous) week/) do |gender,next_or_previous|
    visits(request.request_uri+'?week='+next_or_previous)
  end
  
  # When he clicks the show link for the user with name 'Foeken'
  When(/(he|she) clicks the show link for the (.*) with (.*) '(.*)'/) do |gender,klass,attribute,value|
    klass = klass.split(' ').join('_') if klass.split(' ').length > 1
    attribute = attribute.split(' ').join('_') if attribute.split(' ').length > 1
    
    id = klass.camelcase.constantize.send("find_by_#{attribute}",value).id
    clicks_get_link "/#{klass.pluralize.downcase}/#{id}"
  end
  
  # When he clicks the edit link for the user with name 'Foeken'
  When(/(he|she) clicks the edit link for the (.*) with (.*) '(.*)'/) do |gender,klass,attribute,value|
    klass = klass.split(' ').join('_') if klass.split(' ').length > 1
    attribute = attribute.split(' ').join('_') if attribute.split(' ').length > 1
    
    id = klass.camelcase.constantize.send("find_by_#{attribute}",value).id
    clicks_get_link "/#{klass.pluralize.downcase}/#{id}/edit"
  end
  
  # When he clicks the destroy link for the user with name 'Foeken'
  When(/(he|she) clicks the destroy link for the (.*) with (.*) '(.*)'/) do |gender,klass,attribute,value|
    klass = klass.split(' ').join('_') if klass.split(' ').length > 1
    attribute = attribute.split(' ').join('_') if attribute.split(' ').length > 1
    
    id = klass.camelcase.constantize.send("find_by_#{attribute}",value).id
    clicks_delete_link "/#{klass.pluralize.downcase}/#{id}"
  end
  
  # When he clicks the destroy link
  When(/(he|she) clicks the destroy link/) do |gender|
    clicks_delete_link("Destroy")
  end
  
  When(/(he|she) confirms the popup/) do |gender|
    dismiss_popup(Webrat::Popup::BUTTON_OK)
  end
  
  When(/(he|she) cancels the popup/) do |gender|
    dismiss_popup(Webrat::Popup::BUTTON_CANCEL)
  end    
  
end