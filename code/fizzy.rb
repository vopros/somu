require 'date'
require 'town'

class Fizzy
  attr_reader :title, :author, :description, :dir
  def initialize posts, dir, title, author = '', description = ''
    @posts, @dir = posts, dir
    @title, @author, @description = title, author, description
    @h1 = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>#{var}</h1>
    @per = 10
  end

  def wrap html
    "<div class='post'>#{html}</div>"
  end

  def header id
    Dir["#{@posts}/#{id}"].each do |post|
      return (File.read post).townify[@h1]
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
      html = wrap (File.read post).townify
      if id == '*'
        fetch = "/#{@dir}/" + post[/(?<=\/)[^\/\.]+(?=\.)/] + '/'
        html.gsub!(@h1) {|h| "<a href='#{fetch}'>#{h}</a>"}
      end
      date = (Time.at birth post).to_date.strftime('%d.%m')
      html.gsub!(/<h1>.+<\/h1>/) {|h| "#{h} <div class='time'>#{date}</div>"} # Date
      out << html
    end; out
  end
end
