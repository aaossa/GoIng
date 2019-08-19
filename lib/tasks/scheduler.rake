desc "This task is called by the Heroku scheduler add-on"
task :create_classes => :environment do
  puts "Create classes: creating classes by preferences..."
  Preference.create_classes
  puts "Create classes: done."
end
