require 'date'

class Fizzy
  attr_reader :name, :author, :description, :url

  def initialize name, author, description, per = 10, url = '/blog/', posts = 'posts', dump = 'timestamps.yml'
    @posts, @url, @per, @dump = posts, url, per, dump # Kinda obvious, huh?
    @name, @author, @description = name, author, description
    @header = /(?<=<h1>).+(?=<\/h1>)/ #=> <h1>(match)</h1>
    @time = (Psych.load_file @dump if File.exists? @dump) || {}
  end

  def title id
    # JS does this; for search engines only
    # For speed, it searches for the header right in Markdown
    File.read("#{@posts}/#{id}")[/^.+(?=\n===+)|(?<=#)[^#\n]+|^.+(?=\n---+)/]
  end

  def link id
    basename = id[/[^\/]+(?=\..+$)/]
    "#{@url}#{basename}/"
  end

  def time id
    Time.at @time[id]
  end

  def show id, page = 1
    all = Dir["#{@posts}/#{id}"]
    all.sort_by! do |file|
      if @time[file].nil?
        @time[file] = Time.now.to_i 
        File.write @dump, Psych.dump(@time)
      end; -@time[file]
    end
    raise "No posts found: #{id}" if all.empty?
    those = page.pred * @per...page * @per
  all[those]; end

  def check page
    edge = page * @per
    not Dir["#{@posts}/*"][edge].nil?
  end

  def post path
    post = path.dress
    post.gsub!(@header) {|h| "<a href='#{link post}'>#{h}</a>"} if id == '*'
    date = (time post).strftime('%d.%m')
    post.gsub!(/<h1>.+<\/h1>/) {|h| "#{h} <div class='time'>#{date}</div>"}
  post; end
end
