class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.decimal :price
      t.references :author, index: true, foreign_key: true
      t.references :publisher, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
