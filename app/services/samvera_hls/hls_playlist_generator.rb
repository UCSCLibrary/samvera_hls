module SamveraHls
  class HlsPlaylistGenerator
    class <<self 
      
      def hls_master_url file_set_id
        File.join("file_set",file_set_id,"hls.m3u8")
      end

      def hls_master_playlist file_set_id, root_url
        # make sure the root url doesn't get any default  params attached (e.g. locale)
        parsed_url = URI::parse(root_url)
        parsed_url.fragment = parsed_url.query = nil
        root_url = parsed_url.to_s

        type = SolrDocument.find(file_set_id).mime_type.split('/')[0]
        config = hls_config[type]
        return nil if config.nil?
        defaults = config["default"]
        playlist = "#EXTM3U\n"
        playlist << "#EXT-X-VERSION:6\n"
        variants(file_set_id).each do |variant| 
          next if variant.blank?
          path, filename = File.split(variant)
          format = filename.gsub(".m3u8","")
          options = defaults.merge(config[format])
          playlist << "#EXT-X-STREAM-INF:PROGRAM-ID=1,"
          playlist << "BANDWIDTH=#{options["maxrate"]},"
          playlist << "CODECS=\"#{options["codec_code"]}\","
          playlist << "RESOLUTION=#{options["resolution"]}\n"
          playlist << File.join(root_url,variant_url(file_set_id,format)) + "\n"
        end
        playlist
      end

      def hls_segment_playlist file_set_id, root_url, format
        # make sure the root url doesn't get any default  params attached (e.g. locale)
        parsed_url = URI::parse(root_url)
        parsed_url.fragment = parsed_url.query = nil
        root_url = parsed_url.to_s

        # initialize timestamp once for whole playlist
        timestamp = Time.now.to_i + 7200

        playlist = ""
        File.open(segment_playlist_path(file_set_id, format),'r') {|file|
          file.each_line do |line|
            if line.include? ".ts" then
              playlist << File.join(root_url,
                                    segment_url_base(file_set_id),
                                    timestamp.to_s,
                                    token(file_set_id,line, timestamp),
                                    line).strip+"\n"
            else
              playlist << line.strip+"\n"
            end
          end
        }
        playlist
      end

      def hls_dir file_set_id
        Hyrax::DerivativePath.derivative_path_for_reference(file_set_id,"hls").gsub(/\.hls\z/,"")
      end

      def derivative_url file_set_id, destination_name 
        derivative_path(file_set_id, destination_name).gsub(Hyrax.config.derivatives_path,"")
      end

      private

      def token_secret
        @token_secret ||= ENV['hls_token_secret']
      end

      def segment_url_base id
        File.join("stream",derivative_url(id, "hls"))
      end

      def token id, line, timestamp
        @token ||=  Digest::SHA256.hexdigest("/" + File.join(segment_url_base(id),timestamp.to_s,line).strip[0...-9] + token_secret)
      end

      def segment_playlist_path id, format
        File.join(hls_dir(id),"#{format}.m3u8")
      end

      def hls_config
        @hls_config ||= YAML.load_file(Rails.root.join('config','hls.yml'))
      end

      def variants id
        variants = Dir.glob(File.join(hls_dir(id),"*.m3u8"))
        variants.map!{ |file| 
          name = File.split(file)[1]
        }
      end
      
      def variant_url id, format 
        File.join("file_set",id,format,"variant.m3u8")
      end
      
      def derivative_path id, destination_name
        derivative_path_service.derivative_path_for_reference(id, destination_name)
      end

      def derivative_path_service
        Hyrax::DerivativePath
      end

    end
  end
end
