get '/*.css' do |css|
  style = "#{settings.styles}/#{css}.css"
  # Make CSS in `styles` folder possible
  return File.read(style) if File.exists?(style)
  # Compile SASS with Compass
  sass :"#{css}", Compass.sass_engine_options
    .merge(views: settings.styles, output: :compressed)
end

configure :production do
  # Cache everything what
  # is OK to cache
  %w[/blog* /*.css /].each do |it|
    before it do
      cache_control :public, max_age: 31536000
      etag $time
    end
  end
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
