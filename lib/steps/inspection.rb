steps_for(:inspection) do
    
  # Then he should not see the words 'Monkey', 'Cart' or 'Ant'
  # Then he should not see the long date 'today'                  ==> 7 july 2008
  # Then he should not see the short date 'today'                 ==> 07-07-2008
  Then(/(he|she) (should|should not) see the (word|words|long date|long dates|short date|short dates|regex|regexes) (.*)/) do |gender,should_or_should_not,multiple,words|
    flunk("A popup with message: '#{visible_popup.message}' is in the way!") if blocked_by_popup?
   
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

    error_words = []
    words.each do |word|                  
      begin      
        response.body.gsub(/\s+/, ' ').should match(/#{word}/)
      rescue
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
    redirector_match = response.body.match(/(document|window).location.href(\s+)=(\s+)"(.*)";?/)
    
    if redirector_match
      url = redirector_match[4];
      visits(url)
    else
      flunk("No redirect javascript code was found!")
    end
    
  end
  
  # Then he should see a popup saying 'Are you sure?'
  Then(/(he|she) should see a popup with the message '(.*)'/) do |gender,message|    
    flunk("No popup was visible") if !blocked_by_popup?    
    if visible_popup.message != message
      flunk("Popup message was: '#{visible_popup.message}' and not '#{message}'")
    end    
  end
  
  # Then he should see errors
  Then(/(he|she) should see errors/) do
    flunk("A popup with message: '#{visible_popup.message}' is in the way!") if blocked_by_popup?
    response.should have_tag("div#errorExplanation")
  end
  
end