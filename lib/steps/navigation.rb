steps_for(:navigation) do
  # When he visits '/pages'
  When(/(he|she) visits ('|")(.*)('|")/) do |gender, single_or_double_1, url, single_or_double_2|
    browser.visits(url)
  end

  # When he clicks the 'Employees' link
  When(/(he|she) clicks (the|the first|the second|the third) ('|")(.*)('|") link/) do |gender,count,single_or_double_1,link,single_or_double_2|
    
    if count == "the"
      browser.clicks_link(link)
    else
      
      counter = 0
      
      case count
        when "the first"
          counter = 0
        when "the second"
          counter = 1
        when "the third"
          counter = 2
      end
      
      link_href = nil
      
      begin
        assert_select("a", link) do |elements|
          elements.each do |element|
            if counter == 0
              link_href = element["href"]
              break
            end
            counter -= 1
          end
        end
      rescue Exception => e
        y e
      end
      
      flunk("Cannot find that link...") unless link_href
      
      if selenium?      
        browser.selenium.click("//a[@href='#{link_href}']")
        browser.wait_for_result(nil)
      else
        browser.visits(link_href)
      end
      
    end
    
  end
      
  # When he clicks the show link for the user with name 'Foeken'
  When(/(he|she) clicks the show link for the (.*) with (.*) ('|")(.*)('|")/) do |gender,klass,attribute,single_or_double_1,value,single_or_double_2|
    klass = klass.split(' ').join('_') if klass.split(' ').length > 1
    attribute = attribute.split(' ').join('_') if attribute.split(' ').length > 1
    
    id = klass.camelcase.constantize.send("find_by_#{attribute}",value).id
    browser.visits "/#{klass.pluralize.downcase}/#{id}"
  end
  
  # When he clicks the edit link for the user with name 'Foeken'
  When(/(he|she) clicks the edit link for the (.*) with (.*) ('|")(.*)('|")/) do |gender,klass,attribute,single_or_double_1,value,single_or_double_2|
    klass = klass.split(' ').join('_') if klass.split(' ').length > 1
    attribute = attribute.split(' ').join('_') if attribute.split(' ').length > 1
    
    id = klass.camelcase.constantize.send("find_by_#{attribute}",value).id

    browser.visits "/#{klass.pluralize.downcase}/edit/#{id}"
  end
  
  # When he clicks the destroy link for the user with name 'Foeken'
  When(/(he|she) clicks the destroy link for the (.*) with (.*) ('|")(.*)('|")/) do |gender,klass,attribute,single_or_double_1,value,single_or_double_2|
    klass = klass.split(' ').join('_') if klass.split(' ').length > 1
    attribute = attribute.split(' ').join('_') if attribute.split(' ').length > 1
    
    id = klass.camelcase.constantize.send("find_by_#{attribute}",value).id

    link = "/#{klass.pluralize.downcase}/#{id}"    
    
    if selenium?    
      browser.selenium.click("//a[contains(@onclick,\"method:'delete'\") and @href='#{link}']")
      browser.wait_for_result(nil)
    else    
      browser.visits "/#{klass.pluralize.downcase}/#{id}", :delete
    end
    
  end
  
  # When he clicks the destroy link
  When(/(he|she) clicks the destroy link/) do |gender|
    if selenium?
      browser.clicks_link("Destroy")
    else
      browser.clicks_delete_link("Destroy")
    end
  end
  
  When(/(he|she) confirms the popup/) do |gender|
    browser.dismiss_popup(Webrat::Popup::BUTTON_OK) unless selenium?
  end
  
  When(/(he|she) cancels the popup/) do |gender|
    browser.dismiss_popup(Webrat::Popup::BUTTON_CANCEL) unless selenium?
  end    
  
end