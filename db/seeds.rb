Dir[Rails.root.join('db', 'seeds', '*.rb')].each do |seed_file|
  puts "\n === Load #{File.basename(seed_file)}"
  load seed_file
end
