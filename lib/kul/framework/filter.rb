module Kul::Filter

  def filter_request(request, request_method)
    response = run_before_filters(request)
    return response unless response.nil?
    response = run_around_filters(request, request_method)
    run_after_filters(request, response)
    response
  end

  def run_around_filters(request, request_method)
    run_these_around_filters(@around_filters, request, request_method)
  end

  def run_after_filters(request, response)
    return if @after_filters.nil?
    @after_filters.each do |filter|
      case
        when filter.respond_to?(:filter)
          filter.filter(request, response)
        when filter.respond_to?(:call)
          filter.call(request, response)
        else
          raise 'Invalid filter type passed in.'
      end
    end
  end

  def run_before_filters(request)
    return if @before_filters.nil?
    @before_filters.each do |filter|
      val = case
        when filter.respond_to?(:filter)
          filter.filter(request)
        when filter.respond_to?(:call)
          filter.call(request)
        else
          raise 'Invalid filter type passed in.'
      end
      return val unless val.nil?
    end
    nil
  end

  def run_these_around_filters(around_filters, request, request_method)
    return request_method.call if around_filters.nil? || around_filters.empty?
    filter, *rest = around_filters
    case
      when filter.respond_to?(:filter)
        filter.filter(request) do
          run_these_around_filters(rest, request, request_method)
        end
      when filter.respond_to?(:call)
        filter.call(request) do
          run_these_around_filters(rest, request, request_method)
        end
      else
        raise 'Invalid filter type passed in.'
    end
  end

end