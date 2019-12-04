require "samvera_hls/derivatives/video_derivatives"
require "samvera_hls/derivatives/audio_derivatives"
require "uri"

module SamveraHls
  module FileSetBehavior
    extend ActiveSupport::Concern

    def self.audio_mime_types
      ['audio/mp3', 'audio/mpeg', 'audio/wav', 'audio/x-wave', 'audio/x-wav', 'audio/ogg', 'audio/flac','audio/x-flac', 'audio/x-aiff', 'audio/aiff', ]
    end

    def self.video_mime_types
      ['audio/mp3', 'audio/mpeg', 'audio/wav', 'audio/x-wave', 'audio/x-wav', 'audio/ogg', 'audio/flac','audio/x-flac', 'audio/x-aiff', 'audio/aiff', ]
    end

    def create_hls_derivatives(filename)
      case mime_type
      when *audio_mime_types
        create_hls_audio_derivatives filename
      when *video_mime_types
        create_hls_video_derivatives filename
      else
        return false
      end
    end

    private

    def audio_mime_types
      self.class.audio_mime_types
    end

    def video_mime_types
      self.class.video_mime_types
    end

    def create_hls_audio_derivatives filename
      outputs = [
        { label: 'hls_hd', format: 'hls_hd', id: id}, 
        { label: 'hls', format: 'hls', id: id}]
      SamveraHls::Derivatives::AudioDerivatives.create(filename,{:outputs => outputs})
    end

    def create_hls_video_derivatives filename
      outputs = [{ label: :thumbnail, format: 'jpg', url: SamveraHls::HlsPlaylistGenerator.derivative_url(id,'thumbnail') },
                 { label: 'hls_high', format: "hls_high", id: id }, 
                 { label: 'hls_med', format: "hls_med", id: id }, 
                 { label: 'hls_low', format: "hls_low", id: id }]
      SamveraHls::Derivatives::VideoDerivatives.create(filename,{:outputs => outputs})
    end

  end
end
