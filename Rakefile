task default: [:run]

task :trim do
  # Only modified after a commit
  # Shrink to 400x400 unless filename contains @
  # Losslessly compress it
end

task :deploy do
  task :trim
  puts 'Commit name:'
  git "commit -m \"#{gets.chomp}\""
  git 'push heroku master'
end

task :run do
  ruby 'config.ru'
end

task :push do
  print 'Commit name: '
  `git add -A`
  `git commit -am "#{STDIN.gets.chomp}"`
  `git push origin master`
end

task :online do
  `git push heroku master`
end

task :town do
end
