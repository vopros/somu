class Fizzy
  attr_reader :title, :author, :description
  def initialize posts, dir, render, title, author = '', description = ''
    @posts, @dir, @render = posts, dir, render
    @title, @author, @description = title, author, description
    @header = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>#{var}</h1>
  end

  def render post
    @render.render File.read post
  end

  def wrap html
    "<div class='post'>#{html}</div>"
  end

  def show id
    out = ''
    Dir["#{@posts}/#{id}"].each do |post|
      html = wrap render post
      title = html[@header]
      if id == '*'
        title = @title
        fetch = "/#{@dir}/" + post[/(?<=\/)[^\/\.]+(?=\.)/] + '/'
        html.gsub!(@header) {|h| "<a href='#{fetch}'>#{h}</a>"}
      end
    out << html; end
  out; end
end
