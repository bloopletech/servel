class Servel::PathnameDecorator < SimpleDelegator
  def initialize(pathname, parent)
    super(pathname)
    @parent = parent
  end

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
    if directory?
      "Dir"
    elsif file?
      extname.sub(/^\./, "")
    else
      ""
    end
  end

  def media_type
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
        type: media_type
      }
    }
  end

  def href
    if @parent
      "../"
    else
      basename
    end
  end

  def name
    if @parent
      "(Parent Directory)"
    else
      basename
    end
  end
end