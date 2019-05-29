
$( window ).load(function(){
  toggleButton = $('button#playlist-toggle');
  toggleButton.appendTo('.mejs__playlist-current');
  toggleButton.show();
})

window.onunload = function(){};
