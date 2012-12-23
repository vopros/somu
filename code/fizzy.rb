class Fizzy
  attr_reader :title, :author, :description, :dir
  def initialize posts, dir, render, title, author = '', description = ''
    @posts, @dir, @render = posts, dir, render
    @title, @author, @description = title, author, description
    @h1 = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>#{var}</h1>
  end

  def render post
    @render.render File.read post
  end

  def wrap html
    "<div class='post'>#{html}</div>"
  end

  def header id
    Dir["#{@posts}/#{id}"].each do |post|
      return render(post)[@h1]
    end
  end

  def show id
    out = ''
    Dir["#{@posts}/#{id}"].each do |post|
      html = wrap render post
      if id == '*'
        fetch = "/#{@dir}/" + post[/(?<=\/)[^\/\.]+(?=\.)/] + '/'
        html.gsub!(@h1) {|h| "<a href='#{fetch}'>#{h}</a>"}
      end; out << html
    end; out
  end
end
