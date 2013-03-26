module TestAppHelper

  def inside_test_server(&block)
    test_server_context 'normal_test_server', &block
  end

  def inside_empty_server(&block)
    test_server_context 'empty_test_server', &block
  end

  def test_server_context(folder)
    path = Dir.getwd
    Dir.chdir File.join(File.dirname(__FILE__), 'testing_files', folder)
    yield
    Dir.chdir path
  end

end