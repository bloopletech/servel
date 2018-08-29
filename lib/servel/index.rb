class Servel::Index
  extend Servel::Instrumentation

  def initialize(url_root:, url_path:)
    @url_root = url_root
    @url_path = url_path
  end

  def render
    Servel::HamlContext.render('index.haml', locals)
  end

  def locals
    {
      url_root: @url_root,
      url_path: @url_path
    }
  end

  instrument :render, :locals
end