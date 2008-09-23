namespace :selenium do
  desc "Start the selenium server"
  task :start do
    pid = fork do
      exec "java -jar #{SELENIUM_PLUGIN_ROOT}/lib/selenium/openqa/selenium-server.jar.txt >> #{RAILS_ROOT}/log/selenium.log"
    end
    # wait a few seconds to make sure it's finished starting
    sleep 3
    puts "Killing this server will also stop Selenium"
    exec "SSL_DISABLED='true' ruby script/server -e test --debugger -p 3800"
  end
end
 
private
 
SELENIUM_PLUGIN_ROOT = File.join(File.dirname(__FILE__), "/../../selenium")