module HydraHls::Derivatives
  class AudioDerivatives < Hydra::Derivatives::AudioDerivatives 
    def self.processor_class
      Processors::AudioProcessor
    end
  end
end
