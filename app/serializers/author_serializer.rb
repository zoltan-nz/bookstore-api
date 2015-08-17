class AuthorSerializer < ActiveModel::Serializer
  attributes :id, :book, :publishing_house
end
