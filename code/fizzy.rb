require 'date'

class Fizzy
  attr_reader :name, :author, :description, :url

  def initialize name, author, description, per = 10, url = '/blog/', posts = 'posts'
    # `name`: Blog’s title, shown in <title>
    # `author`: Blog’s author, used in the header & meta
    # `description`: What is blog about, used in the meta
    # `per`: Posts per page
    # `url`: Absolute URL of the blog (with prepending and trailing slashes)
    # `posts`: Folder where posts are located
    @posts, @url, @per = posts, url, per # Kinda obvious, huh?
    @name, @author, @description = name, author, description
  end

  def title post
    # JS does this; for search engines only
    # For speed, it searches for the header right in Markdown
    File.read(Dir["#{@posts}/#{post}"]
      .first)[/^.+(?=\n===+)|(?<=#)[^#\n]+|^.+(?=\n---+)/]
  end

  def link path, symbol = ''
    # Make a link to the post
    # NB! Method takes a path, not an id
    @url + symbol + path[/[^\/]+(?=\..+$)/] + '/'
  end

  def time path
    # Gets a timestamp from Redis
    # and converts it to an integer
    Time.at $redis.get(path).to_i
  end

  def show post, page = 1
    # Generates an array which
    # contains all the posts matching
    # `post` and `page` you’ve provided
    all = Dir["#{@posts}/#{post}"]
    raise "No posts found: #{post}" if all.empty?
    all.sort_by! do |path|
      # Gets a timestamp from the Redis
      # and if it doesn’t exist, use &
      # set it to the current time.
      timestamp = $redis.get(path)
      $redis.set(path, Time.now.to_i) if timestamp.nil?
      timestamp ||= Time.now.to_i
      -timestamp.to_i # Inverted order
    end
    # Pagination: parse only this page
    those = (page.pred * @per)...(page * @per)
  all[those]; end

  def check post, page
    # Checks if the page exists
    # (good for pagination)
    not Dir["#{@posts}/#{post}"][page * @per].nil?
  end

  def post path, post
    # Inject some visual features
    # of the blog (links, time)
    html = path.dress
    html.gsub!(/(?<=<h1>).+(?=<\/h1>)/) {|h| "<a href='#{link path}'>#{h}</a>"} if post == '*'
    html.gsub!(/<h1>.+<\/h1>/) {|h| "#{h} <div class='time'>#{time(path).strftime('%d.%m')}</div>"}
  end
end
