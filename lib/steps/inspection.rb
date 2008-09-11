#
# Call the function tag on all objects in the tree of children,
# if they respond to the object. Then add these to the array of results
# 
def retrieve_all_tags(element, tag = :content)
  result = []
  if(element.respond_to? tag)
    result << element.send(tag)
  end
  if element.respond_to? :children
    element.children.each do |child|
      result += retrieve_all_tags(child, tag)
    end    
  end   
  return result  
end


def prepare_words(words, multiple)

  words = words.scan(/('([^']*)'|"([^"]*)")/).to_a.map{ |w| w[1] || w[2] }    
  words = words.map(&:strip)
    
  # Enable correct quoting...
  words = words.map do |word|      
    if word.starts_with?("'")
      if word.ends_with?("'")
        word = word[(1..word.length-2)]
      else
        flunk("Syntax error: #{word} started with a quote but did not end with one...")
      end
    elsif word.starts_with?('"')
      if word.ends_with?('"')
        word = word[(1..word.length-2)]
      else
        flunk("Syntax error: #{word} started with a double quote but did not end with one...")
      end
    else
      word
    end      
  end
  
  if multiple == "long date" || multiple == "long dates"
    words = words.map{ |d| Chronic.parse(d).to_date.to_s(:long) }
  elsif multiple == "short date" || multiple == "short dates"
    words = words.map{ |d| Chronic.parse(d).to_date.to_s(:euro_date_part) }
  end
  
  if multiple != "regex" && multiple != "regexes"
    words = words.map{ |d| Regexp.escape(d) }
  end
  return words
end

steps_for(:inspection) do
    
  # Then he should not see the words 'Monkey', 'Cart' or 'Ant'
  # Then he should not see the long date 'today'                  ==> 7 july 2008
  # Then he should not see the short date 'today'                 ==> 07-07-2008
  Then(/(he|she) (should|should not) see the (word|words|long date|long dates|short date|short dates|regex|regexes) (.*)/) do |gender,should_or_should_not,multiple,words|
    flunk("A popup with message: '#{browser.popup_message}' is in the way!") if blocked_by_popup?  
    
    words = prepare_words(words, multiple)
    error_words = []
    words.each do |word|                  
      begin
        browser.body.gsub(/\s+/, ' ').should match(/#{word}/)        
      rescue Exception => e
        error_words << word      
      end
    end

    if should_or_should_not == "should"
      
      if !error_words.empty?
        flunk "Cannot find the #{multiple}: #{error_words.map{ |w| "'#{w}'" }.to_sentence} anywhere on this page"
      end
      
    elsif should_or_should_not == "should not"
      
      if error_words.length != words.length
        words_on_page = words - error_words
        flunk "I found the #{words_on_page.length > 1 ? "words" : "word"}: #{words_on_page.map{ |w| "'#{w}'" }.to_sentence} somewhere on this page"
      end
      
    end
    
  end
  
  # Then he should be redirected by javascript
  Then(/(he|she) should be redirected by javascript/) do |gender|
    
    return if selenium?
    
    redirector_match = browser.body.match(/(document|window).location.href(\s+)=(\s+)"(.*)";?/)
    
    if redirector_match
      url = redirector_match[4];
      browser.visits(url)
    else
      flunk("No redirect javascript code was found!")
    end
    
  end
  
  # Then he should see a popup saying 'Are you sure?'
  Then(/(he|she) should see a popup with the message '(.*)'/) do |gender,message|
    
    if selenium?
      
      seen_message = browser.selenium.get_confirmation
      if seen_message != message
        flunk("Popup message was: '#{seen_message}' and not '#{message}'")
      end
      
    else
      
      flunk("No popup was visible") if !blocked_by_popup?    
      if visible_popup.message != message
        flunk("Popup message was: '#{browser.popup_message}' and not '#{message}'")
      end    
      
    end
  end
  
  # Then he should see errors
  Then(/(he|she) should see errors/) do
    flunk("A popup with message: '#{browser.popup_message}' is in the way!") if blocked_by_popup?
    browser.body.should have_tag("div#errorExplanation")
  end
  
  Then(/(he|she) should see (a|the|the first) (table|box)( with id '(.*)')?/) do |gender,a_or_the,element,name,t|
    @element_type = element
    element = 'div' if element == 'box'

    if name                
      @select_query = "#{element}[id=\"#{t}\"]"
     
      assert_select @select_query do |tables|
        assert_equal(1, tables.size)
        @element = tables.first
      end
    else      
      @select_query = element
      assert_select("table") do |tables|        
        if(a_or_the == "the first")
          assert(tables.size > 0)
          @element = tables.first;
        else
          assert_equal(1, tables.size)
          @element = tables.first;
        end
      end
      #y @element 
    end
  end


  
  Then(/the (first|second|third|fourth|fifth|sixth|current|next) row (should|should not) contain the (word|words|long date|long dates|short date|short dates|regex|regexes) (.*)/) do |first_or_next, should_or_should_not, multiple, words| 
       
    words = prepare_words(words, multiple)
    
    if first_or_next == "first" || !@row_number
      @row_number = 0;            
    elsif first_or_next =="second"
      @row_number = 1;            
    elsif first_or_next =="third"
      @row_number = 2;            
    elsif first_or_next =="fourth"
      @row_number = 3;            
    elsif first_or_next =="fifth"
      @row_number = 4;            
    elsif first_or_next =="sixth"
      @row_number = 5;            
    elsif first_or_next == "current"
    else
      @row_number = @row_number + 1
    end    
    
    error_words = []
    
    element_type = 'tr' if @element_type == 'table'
    element_type = 'div' if @element_type == 'box'
    rows = @element.children.select {|child| child.respond_to?(:name) && child.name == element_type}            
    row = rows[@row_number] 
    content_list = retrieve_all_tags(row)    
    words.each do |word|
      begin        
        content_list.select { |x| x.match(/#{word}/)}.length.should > 0
      rescue
        error_words << word
      end
    end
    
    
    if should_or_should_not == "should"
      
      if !error_words.empty?
        flunk "Cannot find the words: #{error_words.map{ |w| "'#{w}'" }.to_sentence} in: #{content_list}"
      end
      
    elsif should_or_should_not == "should not"
      
      if error_words.length != words.length
        words_on_page = words - error_words
        flunk "I found the #{words_on_page.length > 1 ? "words" : "word"}: #{words_on_page.map{ |w| "'#{w}'" }.to_sentence} in: #{content_list}"
      end
      
    end
          
  end
  
end