class CreateRegistrationStates < ActiveRecord::Migration[6.0]
  def change
    create_table :registration_states do |t|
      t.string :name, index: true,null: false,unique: true
      t.timestamps
    end
  end
end
