module SamveraHls
  module SolrDocumentBehavior
    extend ActiveSupport::Concern

    
    def hls_master_url
        File.join("file_set",id,"hls.m3u8")
    end

    def hls_master_playlist root_url
      root_url = root_url.gsub("/?locale=en","")
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
      root_url = root_url.gsub("/?locale=en","")
      playlist = ""
      File.open(segment_playlist_path(format),'r') {|file|
        file.each_line do |line|
          if ENV["RAILS_ENV"] == 'development'
            this_segment_url = File.join(root_url,
                                         segment_url_base,
                                         line).strip 
          else
            this_segment_url = File.join(root_url,
                                         segment_url_base,
                                         timestamp.to_s,
                                         token(line),
                                         line).strip
          end
          if line.include? ".ts" then
            playlist << this_segment_url + "\n"
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

    
    def token line
      @token ||=  Digest::SHA256.hexdigest("/" + File.join(segment_url_base,timestamp.to_s,line).strip[0...-9] + token_secret)
    end

    def timestamp
      @timestamp ||= Time.now.to_i + 7200
    end

    def token_secret
      if ENV["RAILS_ENV"] == 'development'
        return ''
      else
        return @token_secret ||= ENV['hls_token_secret']
      end
    end

    def hls_config
      @hls_config ||= YAML.load_file(Rails.root.join('config','hls.yml'))
    end

    def segment_playlist_path format
        File.join(derivative_dir,"hls",format+".m3u8")
    end

    def derivative_dir
      File.split(derivative_path("dummy"))[0]
    end

    def derivative_path destination_name
      derivative_path_service.derivative_path_for_reference(self, destination_name)
    end

    def derivative_path_service
      Hyrax::DerivativePath
    end

  end
end
