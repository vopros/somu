# encoding: utf-8
Dir.chdir File.dirname(__FILE__)
require 'bundler/setup'
Bundler.require :default

Dir["./code/*.rb"].each {|file| require file}
set :styles, 'styles'
set :views, 'views'
set :public_folder, 'public'
set :port, 1996

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

require './app'

configure :production do
  Bundler.require :development
  set :cache_output_dir, '/app/public/cache/'
  set :cache_enabled, true
  error {File.read 'views/error.html'}
  set :show_exceptions, false
  run Sinatra::Application
end
