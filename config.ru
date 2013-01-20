# encoding: utf-8
Dir.chdir File.dirname(__FILE__)
require 'bundler/setup'
Bundler.require :default

Dir["./code/*.rb"].each {|file| require file}
set :public_folder, 'public'
set :views, 'templates'
set :styles, 'styles'

$i = Instajour.new(
  '206005842.5d3b7bd.5a58ba2f68e247a9b97839bf6a5eb6a0',
  'Инстажур Георгия',
  'Георгий Тимощенко',
  'Образы, которые меня впечатлили.'
)

$f = Fizzy.new(
  'Блог Георгия Тимощенко',
  'Георгий Тимощенко',
  'Околодизайн, и всё, чем я интересуюсь.'
)

ENV['MYREDIS_URL'] = 'redis://:DQR22hCCCcHnHWvv6x@pikachu.ec2.myredis.com:7126/'
$redis = Redis.new driver: :hiredis, url: ENV['MYREDIS_URL']
# Delete all unnecessary keys
# from Redis (bad boy feature)
dir = Dir["#{$f.posts}/*"]
$redis.keys('*').each do |key|
  $redis.del(key) unless dir.include? key
end

# Run it!
set :port, 1996
require './app'

configure :production do
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
  error {File.read 'views/error.html'}
  run Sinatra::Application
end
