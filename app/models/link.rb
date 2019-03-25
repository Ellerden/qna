class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true
  validates :url, url: true

  GIST_MASK = /^https:\/\/gist\.github\.com\/\w+\/\w+/i

  def gist?
    url.match?(GIST_MASK)
  end

  def gist_content
    if gist?
      # #<MatchData "gist.github.com/zhengjia/428105" address:"428105">
      gist = url.match(/gist.github.com\/\w+\/(?<address>\w+)/i)[1]
      GistContentService.new(gist).call
    end
  end
end
