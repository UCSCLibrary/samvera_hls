
$( window ).load(function(){
  toggleButton = $('button#playlist-toggle');
  toggleButton.appendTo('.mejs__playlist-current');
  toggleButton.show();
})

window.onunload = function(){};

$(window).bind("pageshow", function(event) {
  alert('pageshow event firing')
  if (event.originalEvent.persisted) {
    alert('reloading the damn thing!')
    window.location.reload(); 
  } else {
    alert('NOT reloading tsdhe damn thing!')
  }
});
