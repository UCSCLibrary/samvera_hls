require "hydra_hls/derivatives/processors"
require "hydra_hls/derivatives/processors/media"
module HydraHls
  module Derivatives
    module Processors
      class Audio < Hydra::Derivatives::Processors::Audio
        include Media

        def options_for(format)
          return super unless format.include?("hls")
          input_options="-y"
          outopts = get_hls_options(format).symbolize_keys
          output_options = "-acodec #{outopts[:acodec]} -b:a #{outopts[:bitrate]} -maxrate: #{outopts[:maxrate]} -f segment -segment_time #{outopts[:segment_time]} -flags -global_header -segment_format mpeg_ts -segment_list_type m3u8"

          { Hydra::Derivatives::Processors::Ffmpeg::OUTPUT_OPTIONS => output_options, 
            Hydra::Derivatives::Processors::Ffmpeg::INPUT_OPTIONS => input_options,
            :format => format}
        end

        def codecs(format)
          return super unless format.include?("hls")
          options = get_hls_options(format)
          "-acodec #{options[:acodec]}"
        end

        private

        def get_hls_options(format)
          config = YAML.load_file(Rails.root.join('config','hls.yml'))["audio"]
          config["default"].merge(config[format])
        end

      end
    end
  end
end
