module Kul::RequestHandler
  attr_accessor :before_filters, :after_filters, :around_filters

  def handle_request(request)
    response = run_before_filters(request)
    return response unless response.nil?
    response = run_around_filters(request, request_handler_method)
    run_after_filters(request, response)
    response
  end

  def run_around_filters(context, method)
    run_these_around_filters(around_filters, context, method)
  end

  def run_after_filters(context, response)
    return if after_filters.nil?
    after_filters.each do |filter|
      case
        when filter.respond_to?(:filter)
          filter.filter(context, response)
        when filter.respond_to?(:call)
          filter.call(context, response)
        else
          raise 'Invalid filter type passed in.'
      end
    end
  end

  def run_before_filters(context)
    return if before_filters.nil?
    before_filters.each do |filter|
      val = case
        when filter.respond_to?(:filter)
          filter.filter(context)
        when filter.respond_to?(:call)
          filter.call(context)
        else
          raise 'Invalid filter type passed in.'
      end
      return val unless val.nil?
    end
    nil
  end

  def run_these_around_filters(around_filters, context, method)
    return method.call(context) if around_filters.nil? || around_filters.empty?
    filter, *rest = around_filters
    case
      when filter.respond_to?(:filter)
        filter.filter(context) do
          run_these_around_filters(rest, context, method)
        end
      when filter.respond_to?(:call)
        filter.call(context) do
          run_these_around_filters(rest, context, method)
        end
      else
        raise 'Invalid filter type passed in.'
    end
  end

end