require "hydra_hls/derivatives/processors/audio"
module HydraHls::Derivatives
  class AudioDerivatives < Hydra::Derivatives::AudioDerivatives 
    def self.processor_class
      HydraHls::Derivatives::Processors::Audio
    end
  end
end
