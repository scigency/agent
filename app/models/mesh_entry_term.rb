class MeshEntryTerm < ActiveRecord::Base
  belongs_to :subject
  
  def self.autocomplete(starts_with, limit = 10)
    mesh = where(["term LIKE ?", "#{starts_with}%"]).limit(limit).order("term asc").includes(:subject).group_by(&:subject)
    mesh.keys.sort_by(&:term).map {|m| {"id" => m.id, "label" => m.term, "value" => m.term, "entries" => mesh[m].reject {|e| m.term == e.term}.map{|e| e.term}.sort}}
  end
end
