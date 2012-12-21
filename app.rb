# encoding: utf-8
Dir["./#{$backend}/*.rb"].each { |file| require file }
require './settings/init'
require 'compass'
require 'sinatra'
require 'slim'

configure do
  Compass.add_project_configuration './settings/compass.rb'
  set :show_exceptions, false
end

error { File.read $error }
set :public, $public
set :port, $port

get '/assets/*.css' do
  css = params[:splat].first
  style = "#{$styles}/#{css}.css"
  return File.read(style) if File.exists?(style)

  set :views, $styles
  sass :"#{css}", Compass.sass_engine_options
end

get '/assets/*.js' do
  js = params[:splat].first
  script = "#{$scripts}/#{js}.js"
  File.read script
end

get '/' do
  slim :index
end

get '/*/?' do
  page = params[:splat].first
  html = "#{$views}/#{page}.html"

  return File.read(html) if File.exists?(html)
  slim :"#{page}"
end
