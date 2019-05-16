class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
  has_many :answers
  has_many :comments
  has_many :files, serializer: Api::FileSerializer
  belongs_to :author, class_name: 'User'
end
