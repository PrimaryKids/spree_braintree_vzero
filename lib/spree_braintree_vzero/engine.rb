module SpreeBraintreeVzero
  class Engine < Rails::Engine
    #require 'spree/core'
    #isolate_namespace Spree
    engine_name 'spree_braintree_vzero'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
    puts "!!!!! #{Rails.root}"
      %w(engines/api/app/controllers).each do |dir|
        Dir["#{Rails.root}/#{dir}/**/*.rb"].sort.each { |f| puts f; require f }
      end

      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        #Rails.configuration.cache_classes ? require(c) : load(c)
        puts c
        require c
      end
    end

    config.to_prepare &method(:activate).to_proc

    initializer 'spree.braintree_vzero.payment_methods', after: 'spree.register.payment_methods' do |app|
      app.config.spree.payment_methods += [
        Spree::Gateway::BraintreeVzeroDropInUI,
        Spree::Gateway::BraintreeVzeroPaypalExpress,
        Spree::Gateway::BraintreeVzeroHostedFields
      ]
    end
  end
end
