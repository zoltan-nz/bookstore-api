# Bookstore Rails API

Based on [this](http://emberigniter.com/modern-bridge-ember-and-rails-5-with-json-api/) tutorial.

## Implementation log

Install rails-api and generate the project.

	gem install rails-api
	rails-api new bookstore-api
	bundle update

Add `active_model_serializers` to `Gemfile`.

	gem 'active_model_serializers', '~> 0.10.0.rc2'
	
Scaffold models and controllers.

	bin/rails generate scaffold book title 'price:decimal{5,2}' author:references publisher:references{polymorphic}
	bin/rails g scaffold author name
	bin/rails g scaffold publishing_house name 'discount:decimal{2,2}'

	bin/rake db:migrate

Add sample data to `db/seeds.rb`.

Update `config/routes.rb` with dashes.

    resources :publishing_houses, path: '/publishing-houses', except: [:new, :edit]

Update `config/application.rb` and comment out `action_mailer` configuration lines.

	require File.expand_path('../boot', __FILE__)

	# require 'rails/all'
	require "active_record/railtie"
	require "action_controller/railtie"
	# require "action_mailer/railtie"
	# require "sprockets/railtie"
	require "rails/test_unit/railtie"

	Bundler.require(*Rails.groups)

	module BookstoreApi
	  class Application < Rails::Application
	    config.active_record.raise_in_transactional_callbacks = true
	  end
	end

Add `config/initializers/json_api.rb`.

	ActiveModel::Serializer.config.adapter = ActiveModel::Serializer::Adapter::JsonApi

Update `app/controllers/application_controller.rb`.

    class ApplicationController < ActionController::API
      include ActionController::Serialization
    end
