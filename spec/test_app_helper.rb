module TestAppHelper
  #before(:each) do
  #  @path = Dir.getwd
  #  Dir.chdir File.join(File.dirname(__FILE__), 'test_app_files')
  #end
  #
  #after(:each) do
  #  Dir.chdir @path
  #end

  def inside_test_app(&block)
    @path = Dir.getwd
    Dir.chdir File.join(File.dirname(__FILE__), 'test_app_files')
    yield
    Dir.chdir @path
  end

  def inside_empty_app
    path = Dir.getwd
    Dir.chdir File.join(File.dirname(__FILE__), 'empty_test_app')
    yield
    Dir.chdir path
  end

end