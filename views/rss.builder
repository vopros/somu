xml.instruct! :xml, :version => "1.0"
xml.rss version: '2.0' do  
  xml.channel do
    xml.title $fizzy.title '*'
    xml.link $fizzy.url
    xml.description $fizzy.description
    $fizzy.sort('*', 1).each do |note|  
      xml.item do
        xml.title note.dress[/(?<=<h1>).+(?=<\/h1>)/]
        xml.link $fizzy.link(note)
        xml.guid $fizzy.link(note)
        xml.pubDate $fizzy.time(note).rfc822  
        xml.description note.dress.gsub!(/<h1>.+<\/h1>/, '')
      end  
    end  
  end
end
