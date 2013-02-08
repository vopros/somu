var initial = document.title;

$('img').mouseenter(function(){
  document.title = $(this).attr('alt');
  $("#favicon").attr("href", $(this).attr('src'));
});

$('img').mouseleave(function(){
  document.title = initial;
  $("#favicon").attr("href", "/favicon.ico");
});
