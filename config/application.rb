require_relative "boot"
require "rails/all"
Bundler.require *Rails.groups
module SampleApp
  class Application < Rails::Application
    config.load_defaults 5.1
    config.action_view.embed_authenticity_token_in_remote_forms = true
    config.generators do |g|
      g.test_framework false
    end
  end
end
