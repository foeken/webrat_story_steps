namespace :selenium do
  desc "Start the selenium server"
  task :start do
    pid = fork do
      exec "java -jar #{SELENIUM_PLUGIN_ROOT}/lib/selenium/openqa/selenium-server.jar.txt -port 4444 >> #{RAILS_ROOT}/log/selenium.log"
    end
    # wait a few seconds to make sure it's finished starting
    sleep 3
    puts "Killing this server will also stop Selenium"
    
    if YAML::load_file("#{RAILS_ROOT}/config/database.yml").has_key?("selenium")
      exec "SSL_DISABLED='true' ruby script/server -e selenium -p 3800"
    else
      exec "SSL_DISABLED='true' ruby script/server -e test -p 3800"
    end
    
  end
end
 
private
 
SELENIUM_PLUGIN_ROOT = File.join(File.dirname(__FILE__), "/../../selenium")