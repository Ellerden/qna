require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }
  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  #validates :url, presence: true, url: true
  # Если дана ссылка на gist, то выводить сразу gist, а не просто ссылку.
end
