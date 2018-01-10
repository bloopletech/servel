class Servel::HomeApp
  def initialize(roots)
    @roots = roots
  end

  def call(env)
    @haml_context ||= Servel::HamlContext.new
    body = @haml_context.render('home.haml', { roots: @roots })

    [200, {}, [body]]
  end
end