document.$scroll = function() {
  var y = $(window).scrollTop();
  var title = '';
  $('h1').each (function() {
    if ($(this).position().top > y + window.innerHeight) return false;
    result = $(this);
    if ($(this).position().top > y) return false;
  });
  if (result) {
    document.title = result.text();
    $("#favicon").attr("href", result.find('img').size() > 0 ?
      result.find('img').attr('src') : "/favicon.ico");
  }
};

$(window).bind ('scroll', document.$scroll);
window.onload = function() {document.$scroll();};
