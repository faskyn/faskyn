class TwitterProductShare
  URL_LENGTH = 23 #defined by twitter API
  SPACE_LENGTH = 1
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
      return basic_text[0...-(difference + text_end.length)] + text_end
    end
  end

  private

    def basic_text
      "#{name}: #{oneliner}"
    end

    def difference
      full_length - TWITTER_MAX
    end

    def full_length
      basic_text.length + SPACE_LENGTH + URL_LENGTH
    end

    def text_end
      "..."
    end
end