source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver", '4.17.0'
end

###############################################################################
# CSS
gem 'bootstrap', '~> 5.3', '>= 5.3.2'
gem 'sassc-rails', '~> 2.1', '>= 2.1.2'

# [https://github.com/igorkasyanchuk/active_storage_validations]
gem 'active_storage_validations'

# 多言語化
gem 'rails-i18n'

# ページネーター [https://github.com/kaminari/kaminari]
gem 'kaminari'

# 定数管理
# [https://github.com/rubyconfig/config]
gem 'config'

# 認証管理 [https://github.com/heartcombo/devise]
gem 'devise'
gem 'devise-i18n'

# テスト用モデルデータ作成
# [https://github.com/thoughtbot/factory_bot_rails]
gem 'factory_bot_rails'

# ダミー値生成
# [https://github.com/faker-ruby/faker]
gem 'faker'

group :development, :test do
  # 環境変数管理
  # [https://github.com/bkeepers/dotenv]
  gem 'dotenv-rails'

  # テストフレームワーク
  # [https://github.com/rspec/rspec-rails]
  gem 'rspec-rails'
end

group :development do
  # DBスキーマ情報をモデルなどにコメント出力
  # [https://github.com/ctran/annotate_models]
  gem 'annotate'

  # Gives letter_opener an interface for browsing sent emails
  # [https://github.com/fgrehm/letter_opener_web]
  gem 'letter_opener_web'

  gem 'better_errors'

  # Mermaid ER図を生成 [https://github.com/koedame/rails-mermaid_erd]
  gem 'rails-mermaid_erd'
end

group :production do
  gem 'aws-sdk-s3', require: false
end
