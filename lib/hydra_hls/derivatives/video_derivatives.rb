module HydraHls::Derivatives
  class UcscVideoDerivatives < Hydra::Derivatives::VideoDerivatives 
    def self.processor_class
      Processors::VideoProcessor
    end
  end
end
