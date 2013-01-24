require 'json'
require 'open-uri'

class Instajour; class << self
  attr_accessor :token, :url, :title, :author, :description
  def configure
    # `token`: Instagram access token, generate here: http://stylehatch.co/instagram/
    # `title`: Title of Instajourm used in <title>
    # `author`: Instajour’s author, used in the meta
    # `description`: What is it about, used in the meta
    @token, @url = '206005842.22c41e6.e73c76e153fd43de8cb9d81b2f13100a', '/instajour/'
    @title, @author, @description = "John Doe's Instajour", 'John Doe', 'Visual innovations.'
    # Configure it!
    yield self
    # Endpoint to access your photos (pre-configured):
    @endpoint = "https://api.instagram.com/v1/users/self/media/recent?count=60&access_token=#{token}"
  end

  def initialize token, title, author, description
    @endpoint = "https://api.instagram.com/v1/users/self/media/recent?count=60&access_token=#{token}"
    @title, @author, @description = title, author, description
  end

  def generate page = nil
    @endpoint += "&max_id=#{page}" unless page.nil? # if specified
    response = JSON.parse open(@endpoint) {|f| f.read } 
    photos, out = [], ''

    response['data'].each do |item|
      caption = item['caption']['text'] unless item['caption'].nil?
      photos << {
        caption: caption || '',
        link: item['link'],
        image: item['images']['low_resolution']['url']
      }
    end

    photos.each do |photo|
      out << "<a
      class='photo'
      href='#{photo[:link]}'>
      <img
        src='#{photo[:image]}'
        alt='#{photo[:caption]}'
        title='#{photo[:caption]}'/>
      </a>"
    end

    # Load next if exists via JS
    after = response['pagination']['next_max_id']
    unless after.nil?
      out << "<script>
      $('body').append('<div class=page></div>');
      $('.page:last').load('#{@url + after}');
      </script>"
    end
  out; end
end; end
