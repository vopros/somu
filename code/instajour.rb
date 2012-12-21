class Instajour
  attr_reader :title, :author, :description
  def initialize token, title, author = '', description = ''
    @endpoint = "https://api.instagram.com/v1/users/self/media/recent?count=60&access_token=#{token}"
    @title = title
    @author = author
    @description = description
  end
  def generate
    
  end
end
