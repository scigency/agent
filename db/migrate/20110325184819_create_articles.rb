class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :journal_id
      t.integer :pubyear
    end
    add_index :articles, :journal_id
  end

  def self.down
    drop_table :articles
  end
end