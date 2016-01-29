class ContactQuestionJob < ActiveJob::Base
  queue_as :default

  def perform(h)
    h = JSON.load(h)
    ContactMailer.contact_email(h['name'],h['email'],h['comment']).deliver
  end
end
