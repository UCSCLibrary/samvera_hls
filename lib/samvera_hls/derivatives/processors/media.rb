module SamveraHls
  module Derivatives
    module Processors
      module Media

        def encode_hls(input_path, options, output_dir)
          segment_base = File.join(output_dir, options[:format])
          segment_list = segment_base + ".m3u8"
          segment_files = segment_base + "_%05d.ts"
          inopts = options[Hydra::Derivatives::Processors::Ffmpeg::INPUT_OPTIONS] ||= "-y"
          outopts = options[Hydra::Derivatives::Processors::Ffmpeg::OUTPUT_OPTIONS] 
          output_files = "-segment_list #{segment_list} #{segment_files}"
          self.class.execute "#{Hydra::Derivatives.ffmpeg_path} #{inopts} -i \"#{input_path}\" #{outopts} #{output_files}"
        end


        def encode_file(file_suffix, options)
          return super(file_suffix,options) unless file_suffix.include?("hls")
          Dir::mktmpdir(['sufia', "_#{file_suffix}"], Hydra::Derivatives.temp_file_base){ |temp_dir|
            encode_hls(source_path, options, temp_dir.to_s)
            SamveraHls::HlsOutputFileService.call(directives, temp_dir)
          }
        end

      end
    end
  end 
end
