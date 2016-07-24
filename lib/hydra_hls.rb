require "hydra_hls/engine"
require "hydra_hls/derivatives"
require "hydra_hls/engine"

module HydraHls

  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Derivatives
  end
end
