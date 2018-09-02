class Servel::Entry
  extend Servel::Instrumentation

  attr_reader :ftype, :type, :media_type, :listing_classes, :icon, :href, :name, :size, :mtime

  def initialize(ftype:, type:, media_type: nil, listing_classes:, icon:, href:, name:, size: nil, mtime: nil)
    @ftype = ftype
    @type = type
    @media_type = media_type
    @listing_classes = listing_classes
    @icon = icon
    @href = href
    @name = name
    @size = size
    @mtime = mtime
  end

  def directory?
    @ftype == :directory
  end

  def file?
    @ftype == :file
  end

  def media?
    !@media_type.nil?
  end

  def as_json(*)
    {
      icon: @icon,
      href: Rack::Utils.escape_path(@href),
      class: @listing_classes,
      mediaType: @media_type,
      name: @name,
      type: @type,
      size: @size.to_i,
      sizeText: @size.nil? ? "-" : @size,
      mtime: @mtime.to_i,
      mtimeText: @mtime.nil? ? "-" : @mtime.strftime("%e %b %Y %l:%M %p"),
      media: media?
    }
  end

  instrument :as_json
end