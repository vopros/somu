# encoding: utf-8
Dir.chdir File.dirname(__FILE__)
require 'bundler/setup'
Bundler.require :default

Dir["./code/*.rb"].each {|file| require file}
set :public_folder, 'public'
set :views, 'templates'
set :styles, 'styles'

Instajour.configure do |c|
  c.token = '206005842.5d3b7bd.5a58ba2f68e247a9b97839bf6a5eb6a0'
  c.title = 'George’s photos'
  c.author = 'George Timoschenko'
  c.description = 'Exciting shapes and forms.'
  c.url = '/photos/'
end

Fizzy.configure do |c|
  c.name = 'Design, Code & Languages'
  c.author = 'Design & Code'
  c.description = 'Semi-design, my beloved projects & interests.'
  c.per = 10
end

configure :development do
  ENV["REDISTOGO_URL"] = `heroku config:get REDISTOGO_URL`
  Town.configure {}
end; $redis = Redis.new driver: :hiredis, url: ENV["REDISTOGO_URL"]
# Delete all unnecessary keys
# from Redis (bad boy feature)
dir = Dir["#{Fizzy.posts}/*"]
$redis.keys('*').each do |key|
  $redis.del(key) unless dir.include? key
end

# Run it!
set :port, 1996
require './app'

configure :production do
  Town.configure do |c|
    # CDN for speed
    # (servers everywhere)
    c.cdn = "http://#{ENV["CDN_SUMO_URL"]}"
  end
  Bundler.require :production
  # Cache everything to
  # minimize Redis queries
  set :cache, Dalli::Client.new
  # Set application deployment
  # time to use in etags as an
  # indetifier in the future
  $time = Time.now
  # Clean it from the last
  # version’s cache
  settings.cache.flush
  use Rack::Cache,
    verbose: false,
    metastore: settings.cache,
    entitystore: settings.cache
  # Errors should be
  # human-readable
  disable :show_exceptions
  error {File.read "#{settings.views}/error.html"}
  run Sinatra::Application
end
