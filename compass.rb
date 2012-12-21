if defined? Sinatra
  project_path = Sinatra::Application.root
  environment = :development
else
  css_dir = 'styles'
  relative_assets = true
  environment = :production
end

sass_dir = 'styles'
images_dir = 'public'

http_path = "/"
http_images_path = ""
http_stylesheets_path = "assets/"

output_style = :compressed # :expanded or :nested or :compact or :compressed
preferred_syntax = :sass
