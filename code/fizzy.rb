require 'date'
require 'psych'
require 'town'

class Fizzy
  attr_reader :name, :author, :description, :url
  def initialize name, author, description, per = 10, url = 'blog', posts = 'posts', dump = '.timestamps'
    @posts, @url, @per, @dump = posts, url, per, dump # Kinda obvious, huh?
    @name, @author, @description = name, author, description
    @header = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>(match)</h1>

    @time = (Psych.load_file @dump if File.exists? @dump) || {}
    File.write @dump, '' unless File.exists? @dump
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
    out = '';
    those = page.pred * @per...page * @per
    all = sort Dir["#{@posts}/#{id}"]

    raise "No posts found: #{id}" if all.empty?
    all[those].each do |post|
      html = "<div class='post'>#{post.dress}</div>"

      if id == '*'
        basename = post[/(?<=\/)[^\/\.]+(?=\.)/]
        fetch = "/#{@url}/#{basename}/"
        html.gsub!(@header) {|h| "<a href='#{fetch}'>#{h}</a>"}
      end

      date = Time.at(@time[post]).to_date.strftime('%d.%m')
      html.gsub!(/<h1>.+<\/h1>/) {|h| "#{h} <div class='time'>#{date}</div>"} # Date
      out << html
    end; out
  end
end
