require 'spec_helper'

describe Kul::ServerFactory do

  context '.create_server' do
    context 'when there is no server.rb file' do
      it 'should return a server object' do
        inside_empty_server do
          test = Kul::ServerFactory.create_server
          test.should be_a Kul::Server
        end
      end
    end

    context 'when the Server class is defined in the server.rb' do
      it 'should return the correct server object' do
        inside_test_server do
          test = Kul::ServerFactory.create_server
          test.should be_a Server
        end
      end
    end

    context 'when the Server class is not defined in the server.rb' do
      it 'should return a Kul::Server object' do
        test_server_context('special_test_server') do
          test = Kul::ServerFactory.create_server
          test.should be_a Kul::Server
          Kernel.method_defined? :some_random_function
        end
      end
    end
  end

  context '.create_controller' do
    it 'creates a controller' do
      inside_test_server do
        test = Kul::ServerFactory.new.create_controller 'foo', 'bar'
        test.should be
        test.should be_a(BarController)
      end
    end

    it 'returns nil if no controller file' do
      inside_empty_server do
        test = Kul::ServerFactory.new.create_controller 'test', 'more_test'
        test.should be_nil
      end
    end

    it 'returns nil if no controller folder' do
      inside_empty_server do
        test = Kul::ServerFactory.new.create_controller 'test', 'blarg'
        test.should be_nil
      end
    end
  end

  context '.create_app' do
    it 'creates an app instance' do
      inside_test_server do
        test = Kul::ServerFactory.new.create_app 'foo'
        test.should be
        test.should be_a FooApp
      end
    end

    it 'creates a base app if there is no app file present' do
      inside_test_server do
        test = Kul::ServerFactory.new.create_app 'no_app'
        test.should be
        test.should be_a Kul::App
      end
    end
  end
end