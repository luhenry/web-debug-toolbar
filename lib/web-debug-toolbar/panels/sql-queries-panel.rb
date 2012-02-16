require 'web-debug-toolbar/panel'

SqlQuery = Struct.new(:name, :sql, :binds, :duration)

class SqlQueriesPanel < Panel
  def initialize(show_cache_queries=true, show_schema_queries=true)
    @show_cache_queries = (show_cache_queries == true)
    @show_schema_queries = (show_schema_queries == true)
    @sql_queries = []
  end

  def show_cache_queries
    return @show_cache_queries
  end

  def show_cache_queries= v
    @show_cache_queries = (v == true)
  end

  def show_schema_queries
    return @show_schema_queries
  end

  def show_schema_queries= v
    @show_schema_queries = (v == true)
  end

  def notifications
    return ['sql.active_record']
  end

  def notify(name, start, finish, id, payload)
    unless payload[:name].nil?
      if payload[:name] == 'CACHE' and not @show_cache_queries
        return
      end

      if payload[:name] == 'SCHEMA' and not @show_schema_queries
        return
      end
    end

    @sql_queries << SqlQuery.new(payload[:name], payload[:sql], payload[:binds], ((finish - start) * 1000).round(1))
  end

  def reset(request, response)
    @sql_queries = [] unless response.response_code == 302
  end

  def render
    @sql_queries.sort! { |a, b| a.name.to_s <=> b.name.to_s }

    sql_queries_count = @sql_queries.length

    sql_queries_render = ''

    File.open(File.expand_path('../views/sql-queries-panel/sql-query.html', File.dirname(__FILE__)), 'r') do |file|
      lines = file.readlines

      @sql_queries.each do |query|
        sql_queries_render += lines.join('').gsub('#{name}', query.name.nil? ? '' : query.name).gsub('#{sql}', query.sql).gsub('#{binds}', query.binds.nil? ? '[]' : query.binds.map{ |bind| bind[1].to_s }.to_s).gsub('#{duration}', "%0.1f" % query.duration)
      end
    end

    sql_queries_panel_render = ''

    File.open(File.expand_path('../views/sql-queries-panel.html', File.dirname(__FILE__)), 'r') do |file|
      sql_queries_panel_render = file.readlines.join('').gsub('#{sql_queries_count}', sql_queries_count.to_s).gsub('#{sql_queries}', sql_queries_render)
    end

    return sql_queries_panel_render
  end
end