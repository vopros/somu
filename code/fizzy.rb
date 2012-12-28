require 'date'
require 'town'

class Fizzy
  attr_reader :name, :author, :description, :url
  def initialize name, author, description, per = 10, posts = 'posts', url = 'blog'
    @posts, @url, @per = posts, url, per # Kinda obvious, huh?
    @name, @author, @description = name, author, description
    @h1 = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>(match)</h1>
  end

  def title id
    # JS does this; for search engines only
    return @name if id == '*'
    Dir["#{@posts}/#{id}"].each do |post|
      return post.dress[@h1]
    end
  end

  def birth file
    `stat -f %B #{file}`.to_i
    # %B timestamp (BSD only?)
  end

  def check page
    edge = page * @per
    not Dir["#{@posts}/*"][edge].nil?
  end

  def show id, page = 1
    out = '';
    those = page.pred * @per...page * @per
    all = Dir["#{@posts}/#{id}"]
      .sort_by {|file| -birth(file) }[those]
      # ↑ Sorts by inversed birth timestamp and fetches

    raise "No posts found: #{id}" if all.empty?
    all.each do |post|

      html = "<div class='post'>#{post.dress}</div>"
      if id == '*'
        fetch = "/#{@url}/" + post[/(?<=\/)[^\/\.]+(?=\.)/] + '/'
        html.gsub!(@h1) {|h| "<a href='#{fetch}'>#{h}</a>"}
      end

      date = (Time.at birth post).to_date.strftime('%d.%m')
      html.gsub!(/<h1>.+<\/h1>/) {|h| "#{h} <div class='time'>#{date}</div>"} # Date
      out << html
    end; out
  end
end
