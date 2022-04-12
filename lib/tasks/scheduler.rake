desc "This task is called by the Heroku scheduler add-on"
task :create_classes => :environment do
  puts "Create classes: creating classes by preferences..."
  Preference.create_classes
  sleep 1.minute
  puts "Create classes: done."
end

desc "Check if a class request is over 2 days old"
task :check_requests => :environment do
  puts "Check requests: checking requests..."
  Request.check_requests
  sleep 1.minute
  puts "Check requests: done."
end
