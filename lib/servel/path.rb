class Servel::Path
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

  def self.top(href)
    Servel::Path.new(
      type: "Dir",
      listing_classes: "top directory",
      icon: "🔝",
      href: href,
      name: "Top Directory"
    )
  end

  def self.parent(href)
    Servel::Path.new(
      type: "Dir",
      listing_classes: "parent directory",
      icon: "⬆️",
      href: href,
      name: "Parent Directory"
    )
  end
end