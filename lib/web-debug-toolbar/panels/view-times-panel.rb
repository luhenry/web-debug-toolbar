require 'web-debug-toolbar/panel'

ViewTime = Struct.new(:route, :duration)

class ViewTimesPanel < Panel
  def initialize
    @views_times = []
  end

  def notifications
    return ['!render_template.action_view']
  end

  def notify(name, start, finish, id, payload)
    @views_times << ViewTime.new(payload[:virtual_path], ((finish - start) * 1000).round(1))
  end

  def reset(request, response)
    @views_times = []
  end

  def render
    view_times_total_duration = 0

    @views_times.each do |view_time|
      view_times_total_duration += view_time.duration
    end

    view_times_render = ''

    File.open(File.expand_path('../views/view-times-panel/view-time.html', File.dirname(__FILE__)), 'r') do |file|
      lines = file.readlines

      @views_times.each do |view_time|
        view_times_render += lines.join('').gsub('#{route}', view_time.route).gsub('#{duration}', "%0.1f" % view_time.duration)
      end
    end

    view_times_panel_render = ''

    File.open(File.expand_path('../views/view-times-panel.html', File.dirname(__FILE__)), 'r') do |file|
      view_times_panel_render = file.readlines.join('').gsub('#{view_times_total_duration}', "%0.1f" % view_times_total_duration).gsub('#{view_times}', view_times_render)
    end

    return view_times_panel_render
  end
end