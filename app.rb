# encoding: utf-8
Dir["./code/*.rb"].each {|file| require file}
require './settings/init'
require 'compass'
require 'sinatra'
require 'slim'

configure do
  Compass.add_project_configuration './settings/compass.rb'
  set :show_exceptions, false
end

error { File.read 'views/error.html' }
def take(var) params[var].to_sym end

set :public, $public
set :port, $port

get '/assets/*.css' do
  css = params[:splat].first
  # If there is a compiled one,
  # take it. Otherwise, use SASS.
  style = "#{$styles}/#{css}.css"
  if File.exists? style
    return File.read style
  end

  set :views, $styles
  sass css.to_sym, Compass.sass_engine_options
end

get '/assets/*.js' do
  js = params[:splat].first
  script = "#{$scripts}/#{js}.js"
  File.read script
end

get '/' do
  set :views, $views
  slim :index
end

get '/*/?' do
  page = params[:splat].first

  html = "#{$views}/#{page}.html"
  if File.exists? html
    return File.read html
  end
  set :views, $views
  slim page.to_sym
end
