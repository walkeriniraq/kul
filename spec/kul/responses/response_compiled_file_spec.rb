require 'spec_helper'
require 'fileutils'

describe ResponseCompiledFile do
  describe '#render_file' do
    context 'given a valid js file and compile path' do
      temp_path = Pathname.new('js/tmp_test.js')
      compile_path = Pathname.new('js/test_coffee.js.coffee')
      after(:each) do
        inside_test_server do
          temp_path.delete if temp_path.exist?
        end
      end
      before(:each) do
        inside_test_server do
          temp_path.delete if temp_path.exist?
        end
      end
      it 'creates a temp file' do
        inside_test_server do
          ResponseCompiledFile.new.render_file compile_path, temp_path
          temp_path.should exist
        end
      end
      it 'compiles into the temp file' do
        inside_test_server do
          ResponseCompiledFile.new.render_file compile_path, temp_path
          IO.read(temp_path).should == "(function() {\n  window.foo = function() {\n    return alert('Hi');\n  };\n\n}).call(this);\n"
        end
      end
      it 'generates a new file when the compilation file is modified' do
        inside_test_server do
          ResponseCompiledFile.new.render_file compile_path, temp_path
          time = temp_path.mtime
          # TODO: this is painful - make it better
          sleep 1
          FileUtils.touch(compile_path)
          ResponseCompiledFile.new.render_file compile_path, temp_path
          temp_path.mtime.should > time
        end
      end
    end
  end
end