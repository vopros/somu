require 'date'
require 'town'

class Fizzy
  attr_reader :title, :author, :description, :url
  def initialize title, author, description, per = 10, posts = 'posts', url = 'blog'
    @posts, @url, @per = posts, url, per
    @title, @author, @description = title, author, description
    @h1 = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>#{var}</h1>
  end

  def wrap html
    "<div class='post'>#{html}</div>"
  end

  def header id
    Dir["#{@posts}/#{id}"].each do |post|
      return post.dress[@h1]
    end
  end

  def birth file
    `stat -f %B #{file}`.to_i
  end

  def check page
    no = page * @per
    Dir["#{@posts}/*"][no].nil?
  end

  def show id, page = 1
    out = ''; no = page * @per
    all = Dir["#{@posts}/#{id}"].sort_by {|p| -birth(p)}[no - @per...no]
    raise "No posts found: #{id}" if all.empty?

    all.each do |post|
      html = wrap post.dress
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
