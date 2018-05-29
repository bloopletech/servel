class Servel::Entry
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
end