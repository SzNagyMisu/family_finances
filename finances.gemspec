$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'finances/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'finances'
  s.version     = Finances::VERSION
  s.authors     = ['Szijjártó-Nagy Misu']
  s.email       = ['szijjarto-nagy.mihaly@ejogseged.hu']
  s.homepage    = nil
  s.summary     = 'temporary: Summary of Finances.'
  s.description = 'temporary: Description of Finances.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 5.1.4'
  s.add_dependency 'haml-rails'
  s.add_dependency 'bootstrap-sass', '~> 3.3.7'
  s.add_dependency 'sass-rails', '~> 5.0'
  s.add_dependency 'coffee-rails', '~> 4.2'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'rails-i18n'

  s.add_development_dependency 'mysql2'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'chromedriver-helper', '~> 1.1.0'
  s.add_development_dependency 'factory_bot_rails'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rails-controller-testing'
  s.add_development_dependency 'timecop'

  s.test_files = Dir['spec/**/*_spec.rb']
end
