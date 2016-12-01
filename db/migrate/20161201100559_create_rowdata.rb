class CreateRowdata < ActiveRecord::Migration[5.0]
  def change
    create_table :rowdata do |t|
      t.string :code
      t.string :div
      t.string :staff
      t.decimal :uriage
      t.decimal :genka

      t.timestamps
    end
  end
end
