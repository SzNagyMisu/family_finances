module Finances
  class Engine < ::Rails::Engine
    isolate_namespace Finances

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
      g.fixture_replacement :factory_bot, :dir => 'spec/factories'
      g.template_engine :haml
    end
  end
end
