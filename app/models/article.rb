class Article < ActiveRecord::Base
  has_many :article_subjects
end
