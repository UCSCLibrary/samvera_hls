$("video.hls_media#primary-media-player").mediaelementplayer({pluginPath: "/mejs/", showPlaylist: false, audioWidth: "100%"});
$("audio.hls_media.single#primary-media-player").mediaelementplayer({pluginPath: "/mejs/", showPlaylist: false, audioWidth: "100%"});

$("audio.hls_media.playlist#primary-media-player").mediaelementplayer({pluginPath: "/mejs/", 
                                                                       showPlaylist: false, 
                                                                       audioWidth: "100%",
                                                                       alwaysShowControls: true,
                                                                       audioWidth: "100%",
                                                                       showPlaylist: true,
                                                                       autoClosePlaylist: true,
                                                                       currentMessage: "now playing: ",
                                                                       features: ["playpause", 
                                                                                  "current", 
                                                                                  "progress", 
                                                                                  "duration", 
                                                                                  "tracks", 
                                                                                  "volume", 
                                                                                  "fullscreen",
                                                                                  "playlist",
                                                                                  "prevtrack", 
                                                                                  "nexttrack", 
                                                                                  "shuffle", 
                                                                                  "loop"]});
