module SamveraHls
  module FileSetsControllerBehavior
    extend ActiveSupport::Concern

#    skip_authorize_resource :only => [:show,:embed,:master,:variant]

    def embed
      response.headers["X-FRAME-OPTIONS"] = "ALLOWALL"
      fs = FileSet.find(params[:id])
      @playlist_url = fs.hls_master_url
      @media_partial = media_display_partial(fs)
      render layout: false
    end
    
    def master
      fs = FileSet.find(params[:id])
      render inline: fs.hls_master_playlist(root_url), content_type: 'application/x-mpegurl'
    end

    def variant
      fs = FileSet.find(params[:id])
      render inline: fs.hls_segment_playlist(root_url,params[:format]), content_type: 'application/x-mpegurl'
    end

    def media_display_partial(file_set)
      'hyrax/file_sets/media_display/' +
        if file_set.image?
          'image'
        elsif file_set.video?
          'video_hls'
        elsif file_set.audio?
          'audio_hls'
        elsif file_set.pdf?
          'pdf'
        elsif file_set.office_document?
          'office_document'
        else
          'default'
        end
    end

  end
end
