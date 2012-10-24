require 'rails'
require 'bundler'
require 'yaml'

if yes?("\n\nAdicionar mecanismo de autenticação? - Devise ")

  gem "devise"
  gem 'devise-i18n'

  generate "devise:install"
  model_name = ask("\n\nQual o nome do model você quer usar? [usuario]")
  model_name = "usuario" if model_name.blank?
  generate("devise", model_name)
  generate("devise:views", model_name)

end

if yes?("\n\nAdicionar mecanismo de autorização? - Cancan")

  gem "cancan"

end

gem 'twitter-bootstrap-rails', '~> 2.1.3'
generate 'bootstrap:install --stylesheet-engine=less'
generate 'bootstrap:layout application fluid --force'

gem 'simple_form'
generate 'simple_form:install --bootstrap'

gem 'thin'

# gem 'google-analytics-rails' - TODO - https://github.com/bgarret/google-analytics-rails

gem 'factory_girl', :group => [ :test ]
gem 'faker', :group => [ :test ]

remove_file "public/index.html"
generate(:controller, "home index")
route "root :to => 'home#index'"

run "bundle install"
git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"