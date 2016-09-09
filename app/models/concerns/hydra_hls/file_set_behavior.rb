require "hydra_hls/derivatives/video_derivatives"
require "hydra_hls/derivatives/audio_derivatives"

module HydraHls
  module FileSetBehavior
    extend ActiveSupport::Concern

    def create_derivatives(filename)
      case mime_type
      when *self.class.audio_mime_types
        hls_dir = File.join(derivative_dir,"hls")
        create_audio_derivates filename, hls_dir
      when *self.class.video_mime_types
        hls_dir = File.join(derivative_dir,"hls")
        create_video_derivates filename, hls_dir
      else
        super
      end
    end

    def hls_master_url
        File.join("file_set",id,"hls.m3u8")
    end

    def hls_master_playlist root_url
        type = mime_type.split('/')[0]
        defaults = hls_config[type]["default"]
        playlist = "#EXTM3U\n"
        playlist << "#EXT-X-VERSION:6\n"
        variants.each{|variant| 
          next if variant.blank?
          path, filename = File.split(variant)
          format = filename.gsub(".m3u8","")
          options = defaults.merge(hls_config[type][format])
          playlist << "#EXT-X-STREAM-INF:PROGRAM-ID=1,"
          playlist << "BANDWIDTH=#{options["maxrate"]},"
          playlist << "CODECS=\"#{options["codec_code"]}\","
          playlist << "RESOLUTION=#{options["resolution"]}\n"
          playlist << File.join(root_url,variant_url(format)) + "\n"
        }
        playlist
    end

    def hls_segment_playlist root_url, format
      playlist = ""
      File.open(segment_playlist_path(format),'r') {|file|
        file.each_line do |line|
          if line.include? ".ts" then
            playlist << File.join(root_url,
                                  segment_url_base,
                                  timestamp.to_s,
                                  token(line),
                                  line).strip+"\n"
          else
            playlist << line.strip+"\n"
          end
        end
      }
      playlist
    end

    private

    def segment_url_base
      File.join("stream",derivative_url,"hls")
    end

    def variants
      variants = Dir.glob(File.join(derivative_dir,"hls","*.m3u8"))
      variants.map!{ |file| 
        name = File.split(file)[1]
      }
    end

    def variant_url format 
        File.join("file_set",id,format,"variant.m3u8")
    end

    def create_audio_derivates filename, hls_dir
      outputs = [
        { label: 'mp3', format: 'mp3', url: derivative_url('mp3') },
        { label: 'ogg', format: 'ogg', url: derivative_url('ogg') },
        { label: 'hls_hd', format: 'hls_hd',path: hls_dir}, 
        { label: 'hls', format: 'hls', path: hls_dir}]
      HydraHls::Derivatives::AudioDerivatives.create(filename,{:outputs => outputs})
    end

    def create_video_derivates filename, hls_dir
      outputs = [{ label: :thumbnail, format: 'jpg', url: derivative_url('thumbnail') },
                 { label: 'webm', format: 'webm', url: derivative_url('webm') },
                 { label: 'mp4', format: 'mp4', url: derivative_url('mp4') },
                 { label: 'hls_high', format: "hls_high", path: hls_dir}, 
                 { label: 'hls_med', format: "hls_med", path: hls_dir}, 
                 { label: 'hls_low', format: "hls_low", path: hls_dir}]
      HydraHls::Derivatives::VideoDerivatives.create(filename,{:outputs => outputs})
    end

    def token line
      @token ||=  Digest::SHA256.hexdigest("/" + File.join(segment_url_base,timestamp.to_s,line).strip[0...-9] + token_secret)
    end

    def timestamp
      @timestamp ||= Time.now.to_i + 7200
    end

    def token_secret
      @token_secret ||= ENV['hls_token_secret']
    end

    def hls_config
      @hls_config ||= YAML.load_file(Rails.root.join('config','hls.yml'))
    end

    def segment_playlist_path format
        File.join(derivative_dir,"hls",format+".m3u8")
    end

    def derivative_url(destination_name = nil)
      if destination_name.nil?
        @deriv_url ||= derivative_dir.gsub(CurationConcerns.config.derivatives_path,"")
      else
        path = derivative_path(destination_name)
        URI("file://#{path}").to_s
      end
    end

    def derivative_dir
      File.split(derivative_path("dummy"))[0]
    end

    def derivative_path destination_name
      CurationConcerns::DerivativePath.derivative_path_for_reference(self, destination_name)
    end


  end
end
