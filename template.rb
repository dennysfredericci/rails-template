require 'yaml'

def replace_content_from_file(file_name, content, new_content)
  text = File.read(file_name)
  result = text.gsub(content, new_content)
  File.open(file_name, "w") {|file| file.puts result}
end

def add_twitter_bootstrap
  gem 'twitter-bootstrap-rails', '>= 2.1.1'
  generate "bootstrap:install --stylesheet-engine=less"
  generate "bootstrap:layout application --force"
end

def add_devise
  gem "devise"
  generate "devise:install"
  #model_name = ask("Qual o nome do model você quer usar? [usuario]")
  model_name = "usuario" if model_name.blank?
  generate("devise", model_name)
end

def add_web_server
  gem "thin"
end

def add_heroku_config
  gem "mysql2"
  replace_content_from_file "Gemfile", /gem 'sqlite3'/, "gem 'pg'"
  database = YAML.load_file('config/database.yml')
  database["production"].clear
  database["production"] = {  "adapter" => "pq", "encoding" => "utf8", "database" => "ENV['DATABASE_URL']", "pool" => 5, "timeout" => 5000 }

  File.open('config/database.yml', 'w') do |out|
    YAML.dump(database, out)
  end

  run "bundle install"

end

def heroku_deploy
  git :add => "."
  git :commit => "-a -m 'Adding heroku config'"
  run "heroku create #{@app_name}"
  git :push => 'heroku master'
  run 'heroku run rake db:migrate'
  run 'heroku open'
end

def custom_config
  remove_file "public/index.html"
  generate(:controller, "home index")
  route "root :to => 'home#index'"

  run "bundle install"
  git :init
  git :add => "."
  git :commit => "-a -m 'Initial commit'"
end

def main
  add_twitter_bootstrap
  add_devise
  add_web_server
  custom_config
  add_heroku_config
  heroku_deploy
end

main