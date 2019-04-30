# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: %("QnA Service" <mail@qna-service.com> )
  layout 'mailer'
end
