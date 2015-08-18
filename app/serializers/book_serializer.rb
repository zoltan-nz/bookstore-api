class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :price
  attribute :author
  attribute :publisher
end
