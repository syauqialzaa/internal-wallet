source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "~> 7.0.8", ">= 7.0.8.4"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "bootsnap", require: false

# jwt authentication
gem "bcrypt", "~> 3.1", ">= 3.1.20"
gem "jwt", "~> 2.8", ">= 2.8.2"

# api dependencies
gem "rack-cors", "~> 2.0", ">= 2.0.2"
gem "active_model_serializers", "~> 0.10.14"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "rails-erd"
end
