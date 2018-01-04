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

  def audio?
    file? && extname && %w(.mp3 .m4a .wav).include?(extname.downcase)
  end

  def media?
    image? || video? || audio?
  end

  def type
    return "video" if video?
    return "image" if image?
    return "audio" if audio?
    "unknown"
  end

  def listing_classes
    klasses = []
    klasses << "media" if media?
    klasses << "image" if image?
    klasses << "video" if video?
    klasses << "audio" if audio?
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