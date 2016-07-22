Rails.application.routes.draw do
  
  get '/file_set/:id/hls.m3u8', to: 'file_sets#master'
  get '/file_set/:id/:format/variant.m3u8', to: 'file_sets#variant'
  get '/file_set/:id/embed', to: 'file_sets#embed'
  
end
