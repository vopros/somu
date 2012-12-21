# encoding: utf-8
require './settings/init'
Dir["./#{$backend}/*.rb"].each {|file| require file}
require 'compass'
require 'sinatra'
require 'slim'

configure do
  Compass.add_project_configuration './settings/compass.rb'
  #set :show_exceptions, false #
end

error { File.read $error }
set :public, $public
set :port, $port

# SASS/Compass & CSS
get '/assets/*.css' do |css|
  style = "#{$styles}/#{css}.css"
  return File.read(style) if File.exists?(style)

  sass :"#{css}", Compass.sass_engine_options.merge(views: $styles)
end

# JS & CoffeeScript
get '/assets/*.js' do |js|
  script = "#{$scripts}/#{js}.js"
  File.read script
end

get '/instajour/:page' do
  $page = params[:page]
  require './settings/instajour'
  $instajour.generate
end

get '/' do
  slim :index
end

# Slim & HTML
get '/*/?' do
  page = params[:splat].first
  html = "#{$views}/#{page}.html"

  return File.read(html) if File.exists?(html)
  slim :"#{page}"
end
