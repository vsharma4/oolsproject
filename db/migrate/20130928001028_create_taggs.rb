class CreateTaggs < ActiveRecord::Migration
  def change
    create_table :taggs do |t|
      t.string :name
      t.references :post

      t.timestamps
    end
    add_index :taggs, :post_id
  end
end
