module Kurgan
  class Projects
    class << self

      attr_reader :properties

      def properties
        @projects={
          empty: {
            components:[],
            parameters:[]
          },
          vpc: {
            components: [
              { name: 'vpc', template: 'vpc' }
            ],
            parameters: []
          },
          ecs: {
            components: [
              { name: 'vpc', template: 'vpc' },
              { name: 'bastion', template: 'bastion'},
              { name: 'loadbalancer', template: 'loadbalancer'},
              { name: 'ecs', template: 'ecs'}
            ],
            parameters: []
          }
        }
      end

    end
  end
end
