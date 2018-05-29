class Servel::EntryFactory
  extend Servel::Instrumentation

  IMAGE_EXTS = %w(.jpg .jpeg .png .gif)
  VIDEO_EXTS = %w(.webm .mp4 .mkv)
  AUDIO_EXTS = %w(.mp3 .m4a .wav)
  TEXT_EXTS = %w(.txt)

  def self.home(href)
    Servel::Entry.new(
      ftype: :directory,
      type: "Dir",
      listing_classes: "home directory",
      icon: "🏠",
      href: href,
      name: "Listings Home"
    )
  end

  def self.top(href)
    Servel::Entry.new(
      ftype: :directory,
      type: "Dir",
      listing_classes: "top directory",
      icon: "🔝",
      href: href,
      name: "Top Directory"
    )
  end

  def self.parent(href)
    Servel::Entry.new(
      ftype: :directory,
      type: "Dir",
      listing_classes: "parent directory",
      icon: "⬆️",
      href: href,
      name: "Parent Directory"
    )
  end

  def self.for(path)
    new(path).entry
  end

  def initialize(path)
    @path_basename = path.basename.to_s
    @path_extname = path.extname.to_s
    stat = path.stat
    @path_mtime = stat.mtime
    @path_size = stat.size
    @path_ftype = stat.ftype.intern
    @path_directory = @path_ftype == :directory
    @path_file = @path_ftype == :file
  end

  instrument :initialize

  def entry
    Servel::Entry.new(
      ftype: @path_ftype,
      type: type,
      media_type: media_type,
      listing_classes: listing_classes,
      icon: icon,
      href: @path_basename,
      name: @path_basename,
      size: size,
      mtime: @path_mtime
    )
  end

  def type
    if @path_directory
      "Dir"
    elsif @path_file
      @path_extname.sub(/^\./, "")
    else
      ""
    end
  end

  def media_type
    return nil unless @path_file && @path_extname

    case @path_extname.downcase
    when *IMAGE_EXTS
      :image
    when *VIDEO_EXTS
      :video
    when *AUDIO_EXTS
      :audio
    when *TEXT_EXTS
      :text
    else
      nil
    end
  end

  def listing_classes
    klasses = []
    klasses << "file" if @path_file
    klasses << "directory" if @path_directory
    klasses << "media" if media_type
    klasses << media_type if media_type
    klasses.join(" ")
  end

  def icon
    return "📁" if @path_directory
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
    @path_directory ? nil : @path_size
  end
end