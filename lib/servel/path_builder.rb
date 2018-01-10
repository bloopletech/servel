class Servel::PathBuilder
  def initialize(path)
    @path = Pathname.new(path)
  end
  
  def build
    Servel::Path.new(
      type: type,
      media_type: media_type,
      listing_classes: listing_classes,
      icon: icon,
      href: @path.basename,
      name: @path.basename,
      size: size,
      mtime: @path.mtime
    )
  end
  
  def image?
    @path.file? && @path.extname && %w(.jpg .jpeg .png .gif).include?(@path.extname.downcase)
  end

  def video?
    @path.file? && @path.extname && %w(.webm .mp4).include?(@path.extname.downcase)
  end

  def audio?
    @path.file? && @path.extname && %w(.mp3 .m4a .wav).include?(@path.extname.downcase)
  end

  def media?
    image? || video? || audio?
  end

  def type
    if @path.directory?
      "Dir"
    elsif @path.file?
      @path.extname.sub(/^\./, "")
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
    klasses << "file" if @path.file?
    klasses << "directory" if @path.directory?
    klasses.join(" ")
  end

  def icon
    if @path.directory?
      "📁"
    elsif video?
      "🎞️"
    elsif image?
      "🖼️"
    elsif audio?
      "🔊"
    else
      "📝"
    end
  end

  def size
    @path.directory? ? nil : @path.size
  end
end