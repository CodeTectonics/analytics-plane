module AnalyticsPlane
  module Adapters
    module ActiveRecord
      class ChartQuery
        def self.add_select_clause(query, chart_config)
          fields = []
          fields << chart_config['x_axis']['attr']

          chart_config['y_axes'].each do |column|
            aggregate = aggregated_attr(column['attr'], column['aggregation'])
            fields << "#{aggregate[0]} AS '#{aggregate[1]}'"
          end

          query.select(fields)
        end

        def self.aggregated_attr(attr, aggregation)
          case aggregation
          when 'count'
            ["COUNT(#{attr})", "num_#{attr}"]
          when 'count_distinct'
            ["COUNT(DISTINCT #{attr})", "num_uniq_#{attr}"]
          when 'average'
            ["AVG(#{attr})", "avg_#{attr}"]
          when 'min'
            ["MIN(#{attr})", "min_#{attr}"]
          when 'max'
            ["MAX(#{attr})", "max_#{attr}"]
          when 'sum'
            ["SUM(#{attr})", "sum_#{attr}"]
          else
            attr
          end
        end

        def self.add_where_clause(query, chart_config)
          return query if chart_config['filters'].blank?

          chart_config['filters'].each do |filter|
            field = filter['attr']
            operator = filter['operator']
            value = filter['value']

            case operator
            when '='
              query = query.where(field => value)
            when '!='
              query = query.where.not(field => value)
            when '>'
              query = query.where("#{field} > ?", value)
            when '>='
              query = query.where("#{field} >= ?", value)
            when '<'
              query = query.where("#{field} < ?", value)
            when '<='
              query = query.where("#{field} <= ?", value)
            when 'contains'
              query = query.where("#{field} LIKE ?", "%#{value}%")
            when 'starts_with'
              query = query.where("#{field} LIKE ?", "#{value}%")
            when 'ends_with'
              query = query.where("#{field} LIKE ?", "%#{value}")
            when 'one_of'
              query = query.where("#{field} IN (?)", value)
            when 'not_one_of'
              query = query.where.not("#{field} IN (?)", value)
            end
          end

          query
        end

        def self.add_group_clause(query, chart_config)
          group_field = chart_config['x_axis']['attr']
          query.group(group_field)
        end

        def self.parse_series_data(data, chart_config)
          return [] if data.empty?

          attrs = data[0].attribute_names
          attrs.delete(chart_config['x_axis']['attr'])

          attrs.map do |attr|
            y_axis = chart_config['y_axes'].find do |col|
              attr == aggregated_attr(col['attr'], col['aggregation'])[1]
            end

            { name: y_axis['label'], data: data.pluck(attr) }
          end
        end

        def self.parse_category_data(data, chart_config, data_source)
          x_axis_attr = chart_config['x_axis']['attr']

          translatable = data_source.translated_columns.include?(x_axis_attr.to_sym)
          data.map do |row|
            return row[x_axis_attr] unless translatable

            I18n.t(row[x_axis_attr], default: row[x_axis_attr])
          end
        end
      end
    end
  end
end
