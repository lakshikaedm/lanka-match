require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module LankaMatch
  class Application < Rails::Application
    config.load_defaults 8.0

    config.generators do |g|
      g.helper false
      g.test_framework :rspec,
        fixtures: false,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: true,
        controller_specs: false,
        system_specs: true

      g.fixture_replacement :factory_bot, dir: "spec/factories"
    end

    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = "Tokyo"
    config.active_record.default_timezone = :local
  end
end
