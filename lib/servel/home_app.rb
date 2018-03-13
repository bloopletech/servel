class Servel::HomeApp
  def initialize(roots)
    @roots = roots
  end

  def call(env)
    Servel::HamlContext.render('home.haml', { roots: @roots })
  end
end