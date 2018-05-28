module Servel::Instrumentation
  def instrument(*method_names)
    return unless ENV["DEBUG"] == "1"

    Array(method_names).each do |method_name|
      original_method_name = "#{method_name}_without_instrumentation"

      alias_method original_method_name, method_name

      cumulative_time_spent = 0

      define_method(method_name) do |*args|
        start = Time.now

        return_value = __send__(original_method_name, *args)

        finish = Time.now
        time_spent = ((finish - start) * 1000.0)
        cumulative_time_spent += time_spent
        puts "Running #{self.class.name}<#{object_id}>##{method_name}: #{time_spent.round(3)}ms (cumulative: #{cumulative_time_spent.round(3)}ms)"

        return_value
      end
    end
  end
end
