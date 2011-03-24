require 'open-uri'
namespace :meshcomplete do
  desc "Import MeSH data."
  task :data => :environment do
    year = Time.now.year
    Subject.delete_all
    MeshEntryTerm.delete_all
    open("ftp://nlmpubs.nlm.nih.gov/online/mesh/.asciimesh/d#{year}.bin") do |f|
      id, term = nil, nil
      entry_terms = []
      f.each_line do |line|
        tag, val = line.strip.split(/ = /, 2)
        case tag
          when "*NEWRECORD" then id, term = nil, nil; sgrp = []
          when "MH" then term = val
          when "UI" then id = val.gsub(/^D0*/, "")
          when /ENTRY/ then entry_terms.push(val.gsub(/\|.+$/, ""))
          when nil then insert_record(id, term, entry_terms); entry_terms = []
        end
      end
    end
  end
end

def insert_record(id, term, entry_terms)
  puts term
  m = Subject.new
  m.id = id
  m.term = term
  m.save!
  e = MeshEntryTerm.create(:subject_id => id, :term => term)
  entry_terms.uniq.each do |t|
    e = MeshEntryTerm.create(:subject_id => id, :term => t)
  end
end