# encoding: utf-8

get '/yale/*' do |search|
  redirect "http://yandex.ru/yandsearch?text=#{search}" if search[/\p{Cyrillic}/]
  redirect "http://google.com/search?q=#{search}"
end

get '/*.css' do |css|
  content_type 'text/css', charset: 'utf-8'
  style = "#{settings.styles}/#{css}"
  options = Compass.sass_engine_options.merge(views: settings.styles, style: :compressed)
  # Make CSS in `styles` folder possible
  # Compile SASS with Compass
  return File.read("#{style}.css") if File.exists?("#{style}.css")
  return scss css.to_sym, options if File.exists?("#{style}.scss")
  sass css.to_sym, options
end

configure :production do
  # Cache everything what is OK to cache.
  %w[/blog* /*.css / /rss/?].each do |it|
    before it do
      # cache_control :public, max_age: 31536000
      etag $time
    end
  end
end

#=> Fizzy

%w[/nolde/all/*/? /blog/all/*/?
/nolde/*/?].each do |it|
  # /nolde/ is my old blog
  # Try to redirect it to the 
  # new one, if it is possible.
  get(it) {|q| redirect "/blog/#{q}"}
end

%w[/nolde/? /blog/~1/?].each do |it|
  get(it) {redirect '/blog'}
end

%w[/rss/? /blog/rss/].each do |it|
  get(it) {content_type 'application/rss+xml', charset: 'utf-8'; builder :rss}
end

get '/blog/?' do
  # Blog main page
  # is the 1st page
  # of all posts.
  @page = 1
  @post = '*'
  slim :blog
end

get '/blog/~*/?' do |page|
  # /blog/~2 is the second
  # page of all posts.
  @page = page.to_i
  @post = '*'
  slim :blog
end

get '/blog/*.txt/?' do |source|
  content_type 'text/plain', charset: 'utf-8'
  File.read "#{Fizzy.posts}/#{source.gsub '/', ':'}.txt"
end

get '/blog/*/?' do |post|
  # /blog/post is the first
  # page of all posts
  # called `post.*`.
  @page = 1
  @post = "#{post.gsub '/', ':'}.*"
  slim :blog
end

%w[/instajour/? /photo/? /p/?].each do |it|
  get(it) { redirect '/photos' }
end

get '/photos/:id' do
  # Just generate it,
  # no layout needed.
  Instajour.generate params[:id]
end

get '/' do
  slim :index
end

# Slim & HTML
get '/*/?' do |page|
  html = "#{settings.views}/#{page}.html"
  # Make HTML in `templates` folder possible.
  return File.read(html) if File.exists?(html)
  slim page.to_sym
end
