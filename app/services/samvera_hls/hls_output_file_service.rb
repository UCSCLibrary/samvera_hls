require 'samvera/derivatives'
module SamveraHls
  class HlsOutputFileService < Hyrax::PersistDerivatives
    def self.call( directives,temp_dir)
      hls_dir =  directives[:path]
      FileUtils.mkdir_p(hls_dir)
      FileUtils.move(Dir.glob(temp_dir+"/*") , hls_dir)
    end  
  end
end
