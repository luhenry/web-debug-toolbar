require 'web-debug-toolbar/panel'

class RequestTimePanel < Panel
  def initialize
    @request_duration = 0
  end

  def notifications
    return ['process_request.around_filter_end']
  end

  def notify(name, start, finish, id, payload)
    @request_duration = finish - start
  end

  def reset(request, response)
    @request_duration = 0
  end

  def render
    request_time_panel_render = ''
    
    File.open(File.expand_path('../views/request-time-panel.html', File.dirname(__FILE__)), 'r') do |file|
      request_time_panel_render = file.readlines.join('').gsub('#{request_duration}', (@request_duration > 0 ? @request_duration * 1000 : 0).round(1).to_s)
    end

    return request_time_panel_render
  end
end