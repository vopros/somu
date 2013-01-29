xml.instruct! :xml, :version => "1.0"
xml.rss version: '2.0' do
  xml.channel do
    xml.title Fizzy.name
    xml.link Fizzy.url
    xml.description Fizzy.description
    Fizzy.show('*', 1).each do |note|
      xml.item do
        xml.title Fizzy.title note[/(?=\/).+/]
        xml.link Fizzy.link note
        xml.guid Fizzy.link note
        xml.pubDate Fizzy.time(note).rfc822  
        xml.description Town.render(File.read note).gsub!(/<h1>.+<\/h1>/, '')
      end
    end
  end
end
