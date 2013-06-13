class CreateProficiencies < ActiveRecord::Migration
  def change
    create_table :proficiencies do |p|
      p.integer :user_id
      p.integer :skill_id
      p.integer :years
      p.boolean :formal
    end
  end
end
