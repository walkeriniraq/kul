require 'spec_helper'

describe Kul::Router do

  context 'default router' do
    context '#handle_extension?' do
      it 'returns true for .js files' do
        described_class.new.handle_extension?('js').should be_true
      end
      it 'returns true for .html files' do
        described_class.new.handle_extension?('html').should be_true
      end
      it 'returns true for .css files' do
        described_class.new.handle_extension?('css').should be_true
      end
      it 'returns false for .rb files' do
        described_class.new.handle_extension?('rb').should be_false
      end
      it 'returns true for test.html files' do
        described_class.new.handle_extension?('test.html').should be_true
      end
    end
  end

  context 'explicit routing' do
  end

  context 'implicit server routing' do
  end
end
