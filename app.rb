# SASS/Compass & CSS
get '/*.css' do |css|
  style = "#{settings.styles}/#{css}.css"
  return File.read(style) if File.exists?(style)
  sass :"#{css}", Compass.sass_engine_options
    .merge(views: settings.styles, output: :compressed)
end

#=> Fizzy

%w[/nolde/all/*/? /blog/all/*/?
/nolde/*/?].each do |it|
  get(it) {|q| redirect "/blog/#{q}"}
end

%w[/nolde/? /blog/~1/?].each do |it|
  get(it) {redirect '/blog/'}
end

%w[/rss/? /blog/rss/].each do |it|
  get(it) {builder :rss}
end

get '/blog/?' do
  @page = 1
  @post = '*'
  slim :blog
end

get '/blog/~*/?' do |page|
  @page = page.to_i
  @post = '*'
  slim :blog
end

get '/blog/*/?' do |post|
  @page = 1
  @post = "#{post}.*"
  slim :blog
end

get '/instajour/?' do
  # Don’t cache it!
  # Too dynamic!
  slim :instajour, cache: false
end

get '/instajour/:id' do
  $i.generate params[:id]
end

get '/' do
  slim :index
end

# Slim & HTML
get '/*/?' do |page|
  html = "#{settings.views}/#{page}.html"
  return File.read(html) if File.exists?(html)
  slim :"#{page}"
end
