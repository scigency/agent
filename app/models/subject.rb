class Subject < ActiveRecord::Base
  has_many :journal_subjects
  has_many :journals, :through => :journal_subjects
  has_many :mesh_trees
  has_many :mesh_entry_terms

  def to_s
    term
  end

  def to_l
    self
  end

  def articles
    articles_counts.split(/\|/).map {|s| s.to_i}
  end

  def direct_articles
    direct_articles_counts.split(/\|/).map {|s| s.to_i}
  end

  def descendant_articles
    descendant_articles_counts.split(/\|/).map {|s| s.to_i}
  end

  def top(year, offset)
    journal_subjects.top(year).includes(:journal).offset(offset)
  end
end
