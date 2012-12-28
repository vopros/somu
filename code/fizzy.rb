require 'date'
require 'psych'
require 'town'

class Fizzy
  attr_reader :name, :author, :description, :url
  def initialize name, author, description, per = 10, url = '/blog/', posts = 'posts', dump = '.timestamps'
    @posts, @url, @per, @dump = posts, url, per, dump # Kinda obvious, huh?
    @name, @author, @description = name, author, description
    @header = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>(match)</h1>
    @time = (Psych.load_file @dump if File.exists? @dump) || {}
  end

  def title id
    # JS does this; for search engines only
    return @name if id == '*'
    Dir["#{@posts}/#{id}"].each do |post|
      return post.dress[@header]
    end
  end

  def sort posts
    posts.sort_by do |file|
      if @time[file].nil?
        @time[file] = Time.now.to_i 
        File.write @dump, Psych.dump(@time)
      end; -@time[file]
    end
  end

  def check page
    edge = page * @per
    not Dir["#{@posts}/*"][edge].nil?
  end

  def show id, page = 1
    all = sort Dir["#{@posts}/#{id}"]
    those = page.pred * @per...page * @per
    raise "No posts found: #{id}" if all.empty?

    out = ''; all[those].each do |post|
      html = "<div class='post'>#{post.dress}</div>"
      if id == '*'
        basename = post[/(?<=\/)[^\/\.]+(?=\.)/]
        direct = "#{@url}#{basename}/"
        html.gsub!(@header) {|h| "<a href='#{direct}'>#{h}</a>"}
      end # Date: convert & put it after H1
      date = (Time.at @time[post]).strftime('%d.%m')
      html.gsub!(/<h1>.+<\/h1>/) {|h| "#{h} <div class='time'>#{date}</div>"}
      out << html
    end; out
  end
end
