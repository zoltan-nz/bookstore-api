# Bookstore Rails API

Based on [this](http://emberigniter.com/modern-bridge-ember-and-rails-5-with-json-api/) tutorial.

## Implementation log

### Setup rails-api

Install latest (`0.4.0`) rails-api, rails (`4.2.3`) and generate the project.

	gem install rails-api
	rails-api new bookstore-api
	bundle update

Add `active_model_serializers` to `Gemfile`.

	gem 'active_model_serializers', '~> 0.10.0.rc2'

The following needs only if rails should listen for requests from outside localhost

(`config/boot.rb`)

    ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

    require 'bundler/setup' # Set up gems listed in the Gemfile.
    require 'rubygems'
    require 'rails/commands/server'

    module Rails
      class Server
        alias :default_options_bk :default_options
        def default_options
          default_options_bk.merge!(Host: '0.0.0.0')
        end
      end
    end

### Scaffolding

Scaffold models and controllers.

	bin/rails generate scaffold book title 'price:decimal{5,2}' author:references publisher:references{polymorphic}
	bin/rails g scaffold author name
	bin/rails g scaffold publishing_house name 'discount:decimal{2,2}'

	bin/rake db:migrate

Add sample data to `db/seeds.rb`. [Link](https://github.com/szines/bookstore-api/blob/master/db/seeds.rb).

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

### Update models and relations

BookSerializer (`app/serializers/book_serializer.rb`)

    class BookSerializer < ActiveModel::Serializer
      attributes :id, :title, :price
      belongs_to :author
      belongs_to :publisher
    end

Author (`app/models/author.rb`)

    class Author < ActiveRecord::Base
        def discount() 10 end
        has_many :books
        has_many :published, foreign_key: :publisher_id, class_name: 'Book', as: :publisher
    end

AuthorSerializer (`app/serializers/author_serializer.rb`)

    class AuthorSerializer < ActiveModel::Serializer
      attributes :id, :name, :discount
      has_many :books
      has_many :published
    end

PublishingHouse (`app/models/publishing_house.rb`)

    class PublishingHouse < ActiveRecord::Base
      has_many :published, as: :publisher, foreign_key: :publisher_id, class_name: 'Book'
    end

PublishingHouseSerializer (`app/serializers/publishing_house_serializer.rb`)

    class PublishingHouseSerializer < ActiveModel::Serializer
      attributes :id, :name, :discount
      has_many :published
    end

### Add books as extra payload to Authors

`app/controllers/authors_controller.rb`

    def show
      render json: @author, include: ['books']
    end

### Add include to BooksController#index

Attach `author` and `publisher` data to generated json.

### Add `oj` gem to the project

`oj` is the fastest json generator gem in ruby world.

## Test requests with Postman

Postman: [link](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop?hl=en)

    GET http://localhost:3000/publishing_houses
    GET http://localhost:3000/authors
    GET http://localhost:3000/books
    GET http://localhost:3000/authors/1

Using curl

    curl http://localhost:3000/publishing-houses | python -m json.tool
