class Pathname
  def decorate(parent: false, top: false)
    Servel::PathnameDecorator.new(pathname: self, parent: parent, top: top)
  end
end