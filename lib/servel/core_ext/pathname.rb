class Pathname
  def decorate
    Servel::PathnameDecorator.new(self)
  end
end