require 'kurgan/init'

module Kurgan
  class Ecs < Kurgan::Init

    def set_template_components
      @components = [
        { name: 'vpc', template: 'vpc'},
        { name: 'bastion', template: 'bastion'},
        { name: 'loadbalancer', template: 'loadbalancer'},
        { name: 'ecs', template: 'ecs'}
      ]
    end

  end
end
