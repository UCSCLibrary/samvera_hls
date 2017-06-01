require 'rails/generators'
class SamveraHls::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def inject_routes
    insert_into_file "config/routes.rb", :after => ".draw do" do
      %{\n  mount SamveraHls::Engine => '/'\n}
    end
  end

  def inject_compile_assets
    insert_into_file "config/initializers/assets.rb", :before => /^end/ do
      %{\nRails.application.config.assets.precompile += %w( include_player.js )\nRails.application.config.assets.precompile += %w( embed.js )\nRails.application.config.assets.precompile += %w( embed.css )\n}
    end
  end

  def inject_file_set_behavior
    insert_into_file "app/models/file_set.rb", 
                     :after => "Sufia::FileSetBehavior" do
      %{\n  include SamveraHls::FileSetBehavior\n}
    end
  end

  def copy_transcoding_config
    copy_file "config/hls.yml.example", "config/hls.yml"
  end

  def copy_file_sets_controller
    copy_file "controllers/file_sets_controller.rb", "app/controllers/file_sets_controller.rb"
  end

end
