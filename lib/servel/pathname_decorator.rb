class Servel::PathnameDecorator < SimpleDelegator
  def decorate
    self
  end

  def image?
    file? && extname && %w(.jpg .jpeg .png .gif).include?(extname.downcase)
  end

  def video?
    file? && extname && %w(.webm).include?(extname.downcase)
  end

  def media?
    image? || video?
  end

  def type
    return "video" if video?
    return "image" if image?
    "unknown"
  end

  def listing_classes
    klasses = []
    klasses << "media" if media?
    klasses << "image" if image?
    klasses << "video" if video?
    klasses.join(" ")
  end

  def listing_attrs
    {
      class: listing_classes,
      data: {
        type: type
      }
    }
  end
end