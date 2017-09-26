class CreateAnswer < ActiveRecord::Migration[5.1]
  def change
    create_table(:answers) do |t|
      t.column(:text, :string)
      t.column(:counter, :integer)
      t.column(:question_id, :integer)
    end
  end
end
