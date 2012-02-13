require 'web-debug-toolbar/toolbar.rb'
require 'web-debug-toolbar/panels/request-time-panel.rb'
require 'web-debug-toolbar/panels/sql-queries-panel.rb'
require 'web-debug-toolbar/panels/view-times-panel.rb'

module WebDebugToolbar
  toolbar = Toolbar.new
  toolbar.add_panel(RequestTimePanel.new)
  toolbar.add_panel(SqlQueriesPanel.new)
  toolbar.add_panel(ViewTimesPanel.new)

  ActiveSupport.on_load(:after_initialize) do
    ActiveSupport::Notifications.subscribe do |name, start, finish, id, payload|
      toolbar.notify(name, start, finish, id, payload)
    end
  end

  ActiveSupport.on_load(:action_controller) do
    append_around_filter { |controller, action|
      request_time_start = Time.now

      action.call

      toolbar.notify('process_request.around_filter_end', request_time_start, Time.now, 0, [])

      javascript = File.open(File.expand_path('web-debug-toolbar/assets/web-debug-toolbar.js', File.dirname(__FILE__)), 'r') do |file|
        file.readlines.join
      end

      css = File.open(File.expand_path('web-debug-toolbar/assets/web-debug-toolbar.css', File.dirname(__FILE__)), 'r') do |file|
        file.readlines.join
      end

      ## Create the box at the top right of the page and put it just before </body>
      body = controller.response.body
      body.sub! /<\/head>/, "<style type=\"text/css\" media=\"screen\" charset=\"utf-8\">#{css}</style><script type=\"text/javascript\" charset=\"utf-8\">#{javascript}</script></head>"
      body.sub! /<\/body>/, "#{toolbar.render}</body>"

      ## Update content-length header and response body content
      controller.response["Content-Length"] = body.size.to_s
      controller.response.body = body

      toolbar.reset(controller)
    }
  end
end
