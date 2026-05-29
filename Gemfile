source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Auth
gem "devise"

# Search & filter
gem "ransack"

# Pagination
gem "kaminari"

# HTTP client
gem "faraday"
gem "faraday-retry"

# Background jobs
gem "sidekiq", "~> 7.0"
gem "sidekiq-cron"
gem "redis", "~> 5.0"

# Image processing (Active Storage)
gem "image_processing", "~> 1.2"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "dotenv-rails"

  # Tests
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "faker"
end

group :development do
  gem "web-console"
end
