xml.instruct! :xml, :version => "1.0"
xml.rss version: '2.0' do
  xml.channel do
    xml.title $f.name
    xml.link $f.url
    xml.description $f.description
    $f.sort('*', 1).each do |note|
      xml.item do
        xml.title $f.title(note)
        xml.link $f.link(note)
        xml.guid $f.link(note)
        xml.pubDate $f.time(note).rfc822  
        xml.description note.dress.gsub!(/<h1>.+<\/h1>/, '')
      end
    end
  end
end
