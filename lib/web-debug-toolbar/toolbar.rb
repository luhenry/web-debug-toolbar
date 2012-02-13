class Toolbar
  def initialize
    @panels = []
  end

  def add_panel(panel)
    @panels << panel
  end

  def notify(name, start, finish, id, payload)
#    puts "name : #{name}, duration : #{finish - start}, id : #{id}, payload : #{payload}"
    
    panels_to_notify = @panels.select { |panel| panel.notifications.include?(name.to_s) }

    panels_to_notify.each do |panel|
      panel.notify(name, start, finish, id, payload)
    end
  end

  def reset(controller)
    @panels.each do |panel|
      panel.reset(controller.request, controller.response)
    end
  end

  def render
    toolbar_panels_render = ''

    @panels.each do |panel|
      toolbar_panels_render += panel.render
    end

    toolbar_render = ''

    File.open(File.expand_path('views/toolbar.html', File.dirname(__FILE__)), 'r') do |file|
      toolbar_render = file.readlines.join('').gsub('#{toolbar_panels}', toolbar_panels_render)
    end

    return toolbar_render
  end
end