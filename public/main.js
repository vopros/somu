document.$scroll = function() {
  var y = $(window).scrollTop();
  var title = '';
  $ ('h1').each (function() {
    if ($(this).position().top > y + window.innerHeight) return false;
    title = $(this).text();
    if ($(this).position().top > y) return false;
  });
  if (title) document.title = title;
};

$(window).bind ('scroll', document.$scroll);
window.onload = function() {document.$scroll();};
