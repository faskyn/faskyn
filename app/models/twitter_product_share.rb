class TwitterProductShare
  URL_LENGTH = 23 #defined by twitter API
  TWITTER_MAX = 140
  attr_reader :name, :oneliner

  def initialize(product)
    @name = product.name
    @oneliner = product.oneliner
  end

  def return_text
    if full_length <= TWITTER_MAX
      return basic_text
    else
      difference = URL_LENGTH - TWITTER_MAX
      return basic_text[0...-(difference + text_end.length)] + text_end
    end
  end

  def basic_text
    "#{name}: #{oneliner}"
  end

  def full_length
    basic_text.length + URL_LENGTH
  end

  def text_end
    "..."
  end
end