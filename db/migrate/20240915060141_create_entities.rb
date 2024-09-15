class CreateEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :entities, id: :uuid do |t|
      t.references :entity, polymorphic: true, null: false, type: :uuid

      t.timestamps
    end
  end
end
