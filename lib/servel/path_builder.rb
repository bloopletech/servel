class Servel::PathBuilder
  IMAGE_EXTS = %w(.jpg .jpeg .png .gif)
  VIDEO_EXTS = %w(.webm .mp4 .mkv)
  AUDIO_EXTS = %w(.mp3 .m4a .wav)

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
    return nil unless @path.file? && @path.extname

    case @path.extname.downcase
    when *IMAGE_EXTS
      :image
    when *VIDEO_EXTS
      :video
    when *AUDIO_EXTS
      :audio
    else
      nil
    end
  end

  def listing_classes
    klasses = []
    klasses << "file" if @path.file?
    klasses << "directory" if @path.directory?
    klasses << "media" if media_type
    klasses << media_type if media_type
    klasses.join(" ")
  end

  def icon
    return "📁" if @path.directory?
    case media_type
    when :video
      "🎞️"
    when :image
      "🖼️"
    when :audio
      "🔊"
    else
      "📝"
    end
  end

  def size
    @path.directory? ? nil : @path.size
  end
end