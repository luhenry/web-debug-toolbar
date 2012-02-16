class RequestPanel < Panel
  def initialize
    @controller = ''
    @action = ''
    @params = {}
    @format = ''
    @method = ''
    @path = ''
  end

  def notifications
    return ['start_processing.action_controller']
  end

  def notify(name, start, finish, id, payload)
    @controller = payload[:controller]
    @action = payload[:action]
    @params = payload[:params]
    @format = payload[:format]
    @method = payload[:method]
    @path = payload[:path]
  end

  def reset(request, response)
    @controller = ''
    @action = ''
    @params = {}
    @format = ''
    @method = ''
    @path = ''
  end

  def render
    request_panel_render = ''

    File.open(File.expand_path('../views/request-panel.html', File.dirname(__FILE__)), 'r') do |file|
      request_panel_render = file.readlines.join('').gsub('#{controller}', @controller.to_s).gsub('#{action}', @action.to_s).gsub('#{params}', @params.to_s).gsub('#{format}', @format.to_s).gsub('#{method}', @method.to_s).gsub('#{path}', @path.to_s)
    end

    return request_panel_render
  end
end