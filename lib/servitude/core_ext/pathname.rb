class Pathname
  def image?
    file? && extname && %w(.jpg .jpeg .png .gif).include?(extname.downcase)
  end
end