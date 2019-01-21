module Kurgan
  module_function

  def components_file(file = nil)
    @components_file = file if file
    @components_file ||= File.join(ENV['HOME'], '.kurgan/components.json')
    @components_file
  end

end
