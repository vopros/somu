require 'date'

class Fizzy; class << self
  attr_accessor :name, :author, :per, :description, :url, :posts
  def configure
    # `title`: Blog’s title, shown in <title>
    # `author`: Blog’s author, used in the header & meta
    # `description`: What is blog about, used in the meta
    # `per`: Posts per page
    # `url`: Absolute URL of the blog (with prepending and trailing slashes)
    # `posts`: Folder where posts are located
    @title, @author, @description = 'Blog Name', 'John Doe', "Yet another Ruby Hacker's blog."
    @posts, @url, @per = 'posts', '/blog/', 10
    # Configure it!
    yield self
  end

  def title post
    # JS does this; for search engines only
    # For speed, it searches for the header right in Markdown
    File.read(Dir["#{@posts}/#{post}"]
      .first)[/^.+(?=\n===+)|(?<=#)[^#\n]+|^.+(?=\n---+)/]
  end

  def link path
    # Make a link to the post
    # NB! Method takes a path, not an id
    @url + path[/[^\/]+(?=\..*$)/].gsub(':', '/') # + '/'
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
    html = Town.render File.read path
    html.gsub!(/(?<=<h1>).+(?=<\/h1>)/) {|h| "<a href='#{link path}'>#{h}</a>"} if post == '*'
    html.gsub!(/<h1>.+<\/h1>/) {|h| "#{h} <div class='time' title='#{time(path).ctime}'>#{time(path).strftime('%e %b').gsub(' ', '&nbsp;')}</div>"}
  end
end; end
