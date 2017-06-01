require "samvera_hls/derivatives/processors/audio"
module SamveraHls::Derivatives
  class AudioDerivatives < Hydra::Derivatives::AudioDerivatives 
    def self.processor_class
      SamveraHls::Derivatives::Processors::Audio
    end
  end
end
