class CreateQuestion < ActiveRecord::Migration[5.1]
  def change
    create_table(:questions) do |t|
      t.column(:text, :string)
      t.column(:survey_id, :integer)
    end
  end
end
