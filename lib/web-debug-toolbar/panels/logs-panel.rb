Log = Struct.new(:name, :start, :finish, :id, :payload)

class LogsPanel < Panel
  def initialize
    @logs = []
  end
  
  def notifications
    return ['sql.active_record', 'process_action.action_controller', 'process_request.around_filter_end', '!render_template.action_view', 'render_partial.action_view'] 
  end
  
  def notify(name, start, finish, id, payload)
    @logs << Log.new(name, start, finish, id, payload)
  end
  
  def reset(request, response)
    @logs = []
  end
  
  def render
    logs_render = ''

    File.open(File.expand_path('../views/logs/log.html', File.dirname(__FILE__)), 'r') do |file|
      lines = file.readlines

      @logs.each do |log|
        logs_render += lines.join('').gsub('#{name}', log.name.to_s).gsub('#{start}', log.start.to_s).gsub('#{finish}', log.finish.to_s).gsub('#{id}', log.id.to_s).gsub('#{payload}', log.payload.to_s)
      end
    end

    logs_panel_render = ''

    File.open(File.expand_path('../views/logs-panel.html', File.dirname(__FILE__)), 'r') do |file|
      logs_panel_render = file.readlines.join('').gsub('#{logs}', logs_render)
    end

    return logs_panel_render
  end
end