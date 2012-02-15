require 'web-debug-toolbar/panel'

SqlQuery = Struct.new(:sql, :binds, :duration)

class SqlQueriesPanel < Panel
  def initialize
    @sql_queries = []
  end

  def notifications
    return ['sql.active_record']
  end

  def notify(name, start, finish, id, payload)
    @sql_queries << SqlQuery.new(payload[:sql], payload[:binds], ((finish - start) * 1000).round(1))
  end

  def reset(request, response)
    @sql_queries = [] unless response.response_code == 302
  end

  def render
    sql_queries_total_duration = 0

    @sql_queries.each do |query|
      sql_queries_total_duration += query.duration
    end

    sql_queries_render = ''

    File.open(File.expand_path('../views/sql-queries-panel/sql-query.html', File.dirname(__FILE__)), 'r') do |file|
      lines = file.readlines

      @sql_queries.each do |query|
        sql_queries_render += lines.join('').gsub('#{sql}', query.sql).gsub('#{binds}', query.binds.nil? ? '[]' : query.binds.map{ |bind| bind[1].to_s }.to_s).gsub('#{duration}', query.duration.to_s)
      end
    end

    sql_queries_panel_render = ''

    File.open(File.expand_path('../views/sql-queries-panel.html', File.dirname(__FILE__)), 'r') do |file|
      sql_queries_panel_render = file.readlines.join('').gsub('#{sql_queries_total_duration}', sql_queries_total_duration.to_s).gsub('#{sql_queries}', sql_queries_render)
    end

    return sql_queries_panel_render
  end
end