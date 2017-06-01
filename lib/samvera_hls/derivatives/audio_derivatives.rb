require "samvera_hls/derivatives/processors/audio"
module SamveraHls::Derivatives
  class AudioDerivatives < Samvera::Derivatives::AudioDerivatives 
    def self.processor_class
      SamveraHls::Derivatives::Processors::Audio
    end
  end
end
