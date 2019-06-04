module SamveraHls
  module FileSetsControllerBehavior
    extend ActiveSupport::Concern

    included do
      skip_before_action :authenticate_user!, :only => [:show,:citation, :stats,  :embed, :master, :variant]
      skip_authorize_resource :only => [:show,:citation, :stats,  :embed, :master, :variant]
    end

    def embed
      response.headers["X-FRAME-OPTIONS"] = "ALLOWALL"
      @playlist_url = File.join("file_set",params[:id],"hls.m3u8")
      @media_partial = media_display_partial(params[:id])
      render layout: false
    end
    
    def master
      render inline: SamveraHls::HlsPlaylistGenerator.hls_master_playlist(params[:id],root_url), content_type: 'application/x-mpegurl'
    end

    def variant
      render inline: SamveraHls::HlsPlaylistGenerator.hls_segment_playlist(params[:id],root_url,params[:format]), content_type: 'application/x-mpegurl'
    end

    def media_display_partial(file_set_id)
      file_set = SolrDocument.find(file_set_id)
      base = 'file_sets/media_display'
        if file_set.image?
          File.join('hyrax',base,'image')
        elsif file_set.video?
          File.join(base,'video_hls')
        elsif file_set.audio?
          File.join(base,'audio_hls')
        elsif file_set.pdf?
          File.join('hyrax',base,'pdf')
        elsif file_set.office_document?
          File.join('hyrax',base,'office_document')
        else
          File.join('hyrax',base,'default')
        end
    end

  end
end
