def migrate
  time = Psych.load('---
  posts/virtue.txt: 1356253256
  posts/fizzy.txt: 1356339809
  posts/fuckyeah.txt: 1356356262
  posts/hail.txt: 1342556411
  posts/instajour.txt: 1345556411
  posts/neasden.txt: 1356703143
  posts/suprematism.txt: 1348704000
  posts/shell.txt: 1357624362
  posts/prompt.txt: 1357626742
  posts/warming.txt: 1357629130
  posts/house-warming.txt: 1357632838
  posts/libertarian.txt: 1357959911')

  time.each do |p, r|
    $redis.set(p, r)
    p $redis.get(p)
  end
end
