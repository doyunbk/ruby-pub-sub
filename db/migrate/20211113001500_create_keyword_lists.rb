class CreateKeywordLists < ActiveRecord::Migration[6.1]
  def change
    create_table :keyword_lists do |t|
      t.text :keyword_list

      t.timestamps
    end
  end
end
