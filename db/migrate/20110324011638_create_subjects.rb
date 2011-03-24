class CreateSubjects < ActiveRecord::Migration
  def self.up
    create_table :subjects do |t|
      t.string  :term,                                        :limit => 128
      t.integer :direct_articles_count,       :default => 0,  :limit => 3
      t.integer :descendant_articles_count,   :default => 0,  :limit => 4
      t.integer :articles_count,              :default => 0,  :limit => 4
      t.integer :start_year,                  :default => 0,  :limit => 2
      t.integer :end_year,                    :default => 0,  :limit => 2
      t.text    :direct_articles_counts
      t.text    :descendant_articles_counts
      t.text    :articles_counts
    end
    add_index :subjects, :term
    add_index :subjects, :articles_count
    add_index :subjects, :direct_articles_count
  end

  def self.down
    drop_table :subjects
  end
end
