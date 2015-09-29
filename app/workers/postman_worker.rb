class PostmanWorker
  include Sidekiq::Worker

  def perform(h, count)
    h = JSON.load(h)
    ContactMailer.contact_email(h['name'],h['email'],h['comment']).deliver_later
  end 
end