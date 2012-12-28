require 'json'
require 'open-uri'

class Instajour
  attr_reader :title, :author, :description
  def initialize token, title, author, description
    @endpoint = "https://api.instagram.com/v1/users/self/media/recent?count=60&access_token=#{token}"
    @title, @author, @description = title, author, description
  end
  def generate page = ''
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
      $('.page:last').load('#{after}');
      </script>"
    end
  out; end
end
