class CreateSetting < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :assessment_frequency
      t.integer :min_assessment
      t.integer :max_assessment
      t.string :country_name, default: ''
      t.integer :min_case_note
      t.integer :max_case_note
      t.string :case_note_frequency
      t.string :client_default_columns, array: true, default: []
      t.string :family_default_columns, array: true, default: []
      t.string :partner_default_columns, array: true, default: []
    end
  end
end
