class Pathname
  def image?
    file? && extname && %w(.jpg .jpeg .png .gif).include?(extname.downcase)
  end

  def video?
    file? && extname && %w(.webm).include?(extname.downcase)
  end
end