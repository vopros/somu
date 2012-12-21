require 'json'
require 'open-uri'

class Instajour
  attr_reader :title
  def initialize token, title, author, description
    @endpoint = "https://api.instagram.com/v1/users/self/media/recent?count=60&access_token=#{token}"
    @title = title
  end
  def generate
    @endpoint += "&max_id=#{$page}" unless $page.nil?
    response = JSON.parse open(@endpoint) {|f| f.read }
    photos = []; out = ''

    response['data'].each do |item|
      caption = item['caption']['text'] unless item['caption'].nil?
      photos << {
        caption: caption || '',
        link: item['link'],
        image: item['images']['low_resolution']['url']
      }
    end

    photos.each do |photo|
      out << "
        <a
          class='photo'
          href='#{photo[:link]}'>
          <img
            src='#{photo[:image]}'
            alt='#{photo[:caption]}'
            title='#{photo[:caption]}'/>
        </a>"
    end

    unless response['pagination']['next_max_id'].nil?
      after = response['pagination']['next_max_id']
      out << "
        <script>
          $('body').append('<div class=page></div>');
          $('.page:last').load('/instajour/#{after}');
        </script>"
    end
    out
  end
end
