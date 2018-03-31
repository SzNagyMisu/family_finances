module Finances
  class Engine < ::Rails::Engine
    isolate_namespace Finances

    config.generators do |generators|
      generators.test_framework :rspec, :fixture => false
      generators.fixture_replacement :factory_bot, :dir => 'spec/factories'
      generators.template_engine :haml
    end

    config.before_initialize do
      config.i18n.load_path |= Dir["#{config.root}/config/locales/**/*.yml"]
    end

    config.after_initialize do
      if Finances.config.menu_object
         Finances.config.menu_object.merge! finances: {
           root:               'expenses_path',
           expenses:           'expenses_path',
           expense_categories: 'expense_categories_path',
           statistics:         'statistics_expenses_path'
         }
      end
    end
  end
end
