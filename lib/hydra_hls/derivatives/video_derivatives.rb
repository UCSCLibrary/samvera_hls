require "hydra_hls/derivatives/processors/video"
module HydraHls
  module Derivatives
    class VideoDerivatives < Hydra::Derivatives::VideoDerivatives 
      def self.processor_class
        HydraHls::Derivatives::Processors::Video
      end
    end
  end
end
