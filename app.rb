# encoding: utf-8
Dir.chdir File.dirname(__FILE__)
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
get '/*.css' do |css|
  style = "#{$styles}/#{css}.css"
  return File.read(style) if File.exists?(style)
  sass :"#{css}", Compass.sass_engine_options.merge(views: $styles)
end

get '/instajour/:page' do
  $instajour.generate params[:page]
end

# Fizzy
%w[/nolde/? /blog/~1/?].each do |it|
  get(it) {redirect '/blog/'}
end

%w[/nolde/all/*/? /blog/all/*/? /nolde/*/?].each do |it|
  get(it) {|q| redirect "/blog/#{q}/"}
end

get('/rss/?') { redirect '/blog/rss/' }
get '/blog/rss/?' do  
  builder :rss
end  

get '/blog/?' do
  @id = '*'
  @page = 1
  slim :blog
end

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
