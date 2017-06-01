require "samvera_hls/derivatives/processors/video"
module SamveraHls
  module Derivatives
    class VideoDerivatives < Samvera::Derivatives::VideoDerivatives 
      def self.processor_class
        SamveraHls::Derivatives::Processors::Video
      end
    end
  end
end
