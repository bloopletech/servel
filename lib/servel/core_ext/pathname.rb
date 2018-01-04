class Pathname
  def decorate(parent = false)
    Servel::PathnameDecorator.new(self, parent)
  end
end