# Bookstore Rails API

Based on [this](http://emberigniter.com/modern-bridge-ember-and-rails-5-with-json-api/) tutorial.

## Implementation log

Install rails-api and generate the project

	gem install rails-api
	rails-api new bookstore-api
	bundle update

Scaffold models and controllers

	bin/rails generate scaffold book title 'price:decimal{5,2}' author:references publisher:references{polymorphic}
	bin/rails g scaffold author name
	bin/rails g scaffold publishing_house name 'discount:decimal{2,2}'

	bin/rake db:migrate
