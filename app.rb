# encoding: utf-8
require './settings'
require 'compass'
require 'sinatra'
require 'slim'

configure do
  Compass.add_project_configuration './compass.rb'
  #set :show_exceptions, false
end

error { File.read $error }
set :public_folder, $public
set :port, $port

# SASS/Compass & CSS
get '/assets/*.css' do |css|
  style = "#{$styles}/#{css}.css"
  return File.read(style) if File.exists?(style)
  sass :"#{css}", Compass.sass_engine_options.merge(views: $styles)
end

# CoffeeScript & JS
get '/assets/*.js' do |js|
  script = "#{$scripts}/#{js}.js"
  File.read script
end

get '/instajour/:page' do
  page = params[:page]
  $instajour.generate page
end

# Fizzy Markdown
get '/blog/?' do
  @id = '*'
  @page = 1
  slim :blog
end

get('/nolde/?') { redirect '/blog/' }
get('/blog/~1/?') { redirect '/blog/' }
get '/blog/~*/?' do |page|
  @id = "*"
  @page = page.to_i
  slim :blog
end

get '/blog/*/?' do |post|
  @id = "#{post}.*"
  @page = 1
  slim :blog
end

get '/' do
  slim :index
end

# Slim & HTML
get '/*/?' do |page|
  html = "#{$views}/#{page}.html"
  return File.read(html) if File.exists?(html)
  slim :"#{page}"
end
