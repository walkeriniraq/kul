require 'spec_helper'

describe Kul::BaseController do
  context '.process_action' do
    it 'returns 404 when neither the method nor the file exists'
    it 'renders an html.erb when the method does not exist'
    it 'renders the return from the method if it exists'
    context 'request context provided to the template' do
      it 'includes the server'
      it 'includes the app'
      it 'includes request parameters'
      it 'includes the request object'
    end
  end
end