class PostCreatorJob < ActiveJob::Base
  queue_as :default

  def perform(post, writer, reader)
    PostMailer.post_created(post, writer, reader).deliver
  end
end