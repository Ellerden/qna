class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  belongs_to :question
  has_many :comments
  has_many :files, serializer: FileSerializer
  belongs_to :author, class_name: 'User'
end
