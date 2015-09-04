class BookSerializer < ActiveModel::Serializer
  cache key: 'book', expires_in: 3.hours

  attributes :id, :title, :price
  belongs_to :author
  belongs_to :publisher
end
