class Servel::Entry
  attr_reader :type, :media_type, :listing_classes, :icon, :href, :name, :size, :mtime

  def initialize(type:, media_type: nil, listing_classes:, icon:, href:, name:, size: nil, mtime: nil)
    @type = type
    @media_type = media_type
    @listing_classes = listing_classes
    @icon = icon
    @href = href
    @name = name
    @size = size
    @mtime = mtime
  end

  def media?
    !@media_type.nil?
  end
end