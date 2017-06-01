require "samvera_hls/engine"
require "samvera_hls/derivatives"
require "samvera_hls/engine"

module SamveraHls

  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :Derivatives
  end
end
