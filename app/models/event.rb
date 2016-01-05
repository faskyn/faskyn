class Event < ActiveRecord::Base
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"

  validates :sender, presence: true
  validates :title, presence: { message: "can't be blank" }
  validates :start_at, presence: { message: "can't be blank"}
  validate :start_date_cannot_be_in_the_past
  validate :start_must_be_before_end_time
  validates :recipient, presence: { message: "must be valid"}
  #validates :content, presence: { message: "can not be blank" }, length: { maximum: 140, message: "can't be longer than 140 characters" }

  scope :between_time, -> (start_time, end_time) do
    where("? < start_at AND start_at < ?", start_time, end_time)
  end
  scope :allevents, -> (u) { where('sender_id = ? OR recipient_id = ?', u.id, u.id) }
  scope :between, -> (sender_id, recipient_id) do
    where("(events.sender_id = ? AND events.recipient_id = ?) OR (events.sender_id = ? AND events.recipient_id = ?)", sender_id, recipient_id, recipient_id, sender_id)
  end

  def self.format_date(date_time)
    Time.at(date_time.to_i).to_formatted_s(:db)  
  end

  def as_json(options = {})
    unless self.start_at.nil? || self.end_at.nil?
      { id: self.id,
        recipientId: self.recipient_id,
        recipientName: self.recipient.profile.full_name,
        senderId: self.sender_id,
        senderName: self.sender.profile.full_name,
        title: self.title,
        description: self.description || "",
        start: start_at.rfc822,
        :end => end_at.rfc822,
        allDay: self.all_day,
        recurring: false 
        #url: Rails.application.routes.url_helpers.user_event_path(self)
      }
    end
  end

  def event_name_company
    [recipient.try(:profile).try(:first_name), recipient.try(:profile).try(:last_name), recipient.try(:profile).try(:company)].join(' ')
  end

  def event_name_company=(name)
    self.recipient = User.joins(:profile).where("CONCAT_WS(' ', first_name, last_name, company) LIKE ?", "%#{name}%").first if name.present?
  rescue ArgumentError
    self.recipient = nil
  end

  # def get_busy_events
    
  #   # service = client.discovered_api('calendar', 'v3')
  #   # result = client.execute(
  #   #   api_method: service.freebusy.query,
  #   #   body_object: { timeMin: start_at,
  #   #                  timeMax: end_at,
  #   #                  items: items},
  #   #   headers: {'Content-Type' => 'application/json'})
  # end

  private

    def start_date_cannot_be_in_the_past
      errors.add(:start_at, "can't be in the past") if start_at < DateTime.now
    end

    def start_must_be_before_end_time
      return unless start_at and end_at
      errors.add(:start_at, "must be before end at") unless start_at < end_at
    end
end
