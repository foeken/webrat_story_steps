steps_for(:authorization) do
      
  # Given he logs in
  Given(/(he|she) is logged in/) do |gender|
            
    begin
      login(@previous_model.username,'123')
      response.body.should match(/1.*/)
    rescue
      flunk "Cannot login using these credentials. Perhaps reference user is not correct?"
    end
    
    visits '/'
    
  end
  
  # Given he logs out
  Given(/(he|she) logs out/) do |gender|
    logout
  end
  
  # Given the user 'Andre' logs in with password '123'
  Given(/the user '(.*)' logs in with password '(.*)'/) do |username,password|
    login(username,password)
    
    begin
      response.body.should match(/1.*/)
    rescue
      flunk "Cannot login using these credentials"
    end
    
    visits '/'
  end
  
  # Given he logs in with password '123'
  # Given she logs in with password '123'
  Given(/(he|she) logs in with password '(.*)'/) do |gender,username,password|
    login(username,password)
    
    begin
      response.body.should match(/1.*/)
    rescue
      flunk "Cannot login using these credentials"
    end
    
    visits '/'
  end
    
  # When he logs out
  When(/(he|she) logs out/) do |gender|
    logout
  end
  
  # Then the user 'Andre' should not be able to log in with password '123'
  Then(/the user '(.*)' should not be able to log in with password '(.*)'/) do |username,password|
    login(username,password)
        
    begin
      response.body.should match(/0.*/)
    rescue
      flunk "Was able to login with wrong credentials"
    end
        
  end
  
end