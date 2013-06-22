require 'spec_helper'

describe Kul::FrameworkFactory do

  describe '.create_server' do
    context 'when there is no server.rb file' do
      it 'should return a server object' do
        inside_empty_server do
          test = Kul::FrameworkFactory.get_server
          test.should be_a Kul::BaseServer
        end
      end
    end
    context 'when the Server class is defined in the server.rb' do
      it 'should return the correct server object' do
        inside_test_server do
          test = Kul::FrameworkFactory.get_server
          test.should be_a Server
        end
      end
    end
    context 'when the Server class is not defined in the server.rb' do
      it 'should return a Kul::Server object' do
        test_server_context('special_test_server') do
          test = Kul::FrameworkFactory.get_server
          test.should be_a Kul::BaseServer
          Kernel.method_defined? :some_random_function
        end
      end
    end
  end

  describe '.get_controller' do
    it 'returns nil if the controller file does not exist' do
      inside_empty_server do
        test = Kul::FrameworkFactory.get_controller Kul::Path.new('more_test')
        test.should be_nil
      end
    end
    it 'returns nil if the folder structure does not exist' do
      inside_empty_server do
        test = Kul::FrameworkFactory.get_controller Kul::Path.new('test')
        test.should be_nil
      end
    end
    it 'returns the module from the file if it exists' do
      inside_test_server do
        test = Kul::FrameworkFactory.get_controller Kul::Path.new('bar')
        test.should be
        test.should be_a Module
        test.to_s.should == 'BarController'
      end
    end
  end

  describe '.factory_instance' do
    it 'returns an instance of the factory' do
      test = Kul::FrameworkFactory.factory_instance
      test.should be
      test.should be_a Kul::FrameworkFactory
    end
    it 'returns the same instance' do
      instance = Kul::FrameworkFactory.factory_instance
      test = Kul::FrameworkFactory.factory_instance
      instance.should equal test
    end
  end

  describe '.load_models' do
    it 'loads the model classes' do
      inside_test_server do
        Kul::FrameworkFactory.load_models()
        Class.const_defined?(:TestClass).should be_true
      end
    end
  end

  describe '#get_server_settings' do
    it 'returns the base server settings' do
      test = Kul::FrameworkFactory.get_server_settings
      test.should be_a Kul::ServerSettings
    end
    it 'returns the same settings' do
      settings = Kul::FrameworkFactory.get_server_settings
      test = Kul::FrameworkFactory.get_server_settings
      test.should equal settings
    end
  end

  describe '#load_class' do
    it 'returns :not_exist if the file does not exist' do
      inside_test_server do
        test = Kul::FrameworkFactory.new.load_class('CompletelyUndefinedThing', 'foo.rb')
        test.should == :file_not_exist
      end
    end
    it 'returns :loaded if the class is loaded' do
      inside_test_server do
        test = Kul::FrameworkFactory.new.load_class('Server', 'server.rb')
        test.should == :load
      end
    end
    it 'returns :no_change for the second request' do
      inside_test_server do
        factory = Kul::FrameworkFactory.new
        factory.load_class('Server', 'server.rb')
        test = factory.load_class('Server', 'server.rb')
        test.should == :no_change
      end
    end
    it 'loads the class' do
      inside_test_server do
        # want to make sure that the class is not defined
        Object.send(:remove_const, :VeryUniqueClass) if Object.const_defined?(:VeryUniqueClass)
        test = Kul::FrameworkFactory.new.load_class(:VeryUniqueClass, 'app/very_unique_class.rb')
        test.should == :load
        Object.const_defined?(:VeryUniqueClass).should be_true
      end
    end
    context 'with a test.rb file' do
      after(:each) { File.delete 'test.rb' if File.exist? 'test.rb' }

      it 'reloads the class' do
        test = change_and_reload_file
        test.should == :reload
        ReloadFoo.new.public_methods.should include :bar
        ReloadFoo.new.public_methods.should_not include :foo
      end
      it 'returns :file_not_exist if the file gets deleted' do
        write_first_file
        factory = Kul::FrameworkFactory.new
        factory.load_class(:ReloadFoo, 'test.rb')
        ReloadFoo.new.public_methods.should include :foo
        File.delete('test.rb')
        test = factory.load_class(:ReloadFoo, 'test.rb')
        test.should == :file_not_exist
        Object.const_defined?(:ReloadFoo).should be_false
      end
      it 'class gets undefined' do
        write_first_file
        factory = Kul::FrameworkFactory.new
        factory.load_class(:ReloadFoo, 'test.rb')
        ReloadFoo.new.public_methods.should include :foo
        File.open('test.rb', 'w') { |file| file.write '' }
        factory.load_class(:ReloadFoo, hacked_pathname('test.rb'))
        Object.const_defined?(:ReloadFoo).should be_false
      end
      context 'in production mode' do
        before(:all) { Kul::FrameworkFactory.get_server_settings.server_mode = :production }
        after(:all) { Kul::FrameworkFactory.get_server_settings.server_mode = :app }

        it 'does not reload the class in production mode' do
          test = change_and_reload_file
          test.should == :no_change
          ReloadFoo.new.public_methods.should_not include :bar
          ReloadFoo.new.public_methods.should include :foo
        end
      end
    end
  end

  def change_and_reload_file
    write_first_file
    factory = Kul::FrameworkFactory.new
    factory.load_class(:ReloadFoo, 'test.rb')
    write_second_file
    factory.load_class(:ReloadFoo, hacked_pathname('test.rb'))
  end

  def write_first_file
    File.open('test.rb', 'w') do |file|
      file.write <<TEMP_CLASS
        class ReloadFoo
          attr_accessor :foo
        end
TEMP_CLASS
    end
  end

  def write_second_file
    File.open('test.rb', 'w') do |file|
      file.write <<TEMP_CLASS
        class ReloadFoo
          attr_accessor :bar
        end
TEMP_CLASS
    end
  end

end