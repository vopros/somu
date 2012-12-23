require 'date'
class Fizzy
  attr_reader :title, :author, :description, :dir
  def initialize posts, dir, render, title, author = '', description = ''
    @posts, @dir, @render = posts, dir, render
    @title, @author, @description = title, author, description
    @h1 = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>#{var}</h1>
  end

  def render post
    md = File.read post
    md.gsub!(/(?<=!)\(/) {|n| "[]#{n}" }  # Better image syntax
    @render.render md
  end

  def wrap html
    "<div class='post'>#{html}</div>"
  end

  def header id
    Dir["#{@posts}/#{id}"].each do |post|
      return render(post)[@h1]
    end
  end

  def birth file
    `stat -f %B #{file}`.to_i
  end

  def show id
    out = ''
    Dir["#{@posts}/#{id}"].sort_by { |p| -birth(p) }.each do |post|
      html = wrap render post
      if id == '*'
        fetch = "/#{@dir}/" + post[/(?<=\/)[^\/\.]+(?=\.)/] + '/'
        html.gsub!(@h1) {|h| "<a href='#{fetch}'>#{h}</a>"}
      end
      date = (Time.at birth post).to_date.strftime('%d.%m')
      html.gsub!(/<h1>.+<\/h1>/) {|h| "#{h} <div class='time'>#{date}</div>"}
      out << html
    end; out
  end
end
