module Concerns::Validatable
  extend ActiveSupport::Concern

  def format_website
    if website.blank?
      self.website = nil
    elsif !self.website[/^https?/]
     self.website = "http://#{self.website}"
    end
  end
end