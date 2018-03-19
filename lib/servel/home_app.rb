class Servel::HomeApp
  FAVICON_PATH = "/favicon.ico"

  def initialize(roots)
    @roots = roots
  end

  def call(env)
    return [404, {}, []] if env["PATH_INFO"] == FAVICON_PATH
    Servel::HamlContext.render('home.haml', { roots: @roots })
  end
end