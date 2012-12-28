# encoding: utf-8

# Folders
Dir["./code/*.rb"].each {|file| require file}
$views = 'views'
$styles = 'styles'
$scripts = 'scripts'
$public = 'public'

# Variables
$error = "#{$views}/error.html"
$port = 1996

# Applications
$instajour = Instajour.new(
  '206005842.5d3b7bd.5a58ba2f68e247a9b97839bf6a5eb6a0',
  'Инстажур Георгия',
  'Георгий Тимощенко',
  'Образы, которые меня впечатлили.'
)

$fizzy = Fizzy.new(
  'Блог Георгия Тимощенко',
  'Георгий Тимощенко',
  'Околодизайн, и всё, о чём я думаю.'
)
