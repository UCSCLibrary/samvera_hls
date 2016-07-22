module HydraHls::Derivatives::Processors
  class Video < Hydra::Derivatives::Processors::Video::Processor
    include Media

    def options_for(format)
      return super unless format.include?("hls")
      input_option_string="-y"
      outopts = get_hls_options(format).symbolize_keys
      output_option_string = "-pix_fmt #{outopts[:pix_fmt]} -vcodec #{outopts[:vcodec]} -acodec #{outopts[:acodec]} -r #{outopts[:r]} -profile:v #{outopts[:profile_v]} -level #{outopts[:level]} -b:v #{outopts[:bitrate]} -maxrate: #{outopts[:maxrate]} -f segment -segment_time #{outopts[:segment_time]} -g #{outopts[:g]} -map 0 -flags -global_header -segment_format mpeg_ts -segment_list_type m3u8 -vf #{outopts[:vf]} "
      
      { Hydra::Derivatives::Processors::Ffmpeg::OUTPUT_OPTIONS => output_option_string, 
        Hydra::Derivatives::Processors::Ffmpeg::INPUT_OPTIONS => input_option_string,
        :format => format}
    end

    def codecs(format)
      return super unless format.include?("hls")
      options = get_hls_options(format)
      "-vcodec #{options[:vcodec]} -acodec #{options[:acodec]}"
    end

    private

    def get_hls_options(format)
      config = YAML.load_file(Rails.root.join('config','transcoding.yml'))["video"]
      config["default"].merge(config[format])
    end
    
  end
end
