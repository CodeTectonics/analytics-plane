module AnalyticsPlane
  module Adapters
    module ActiveRecord
      class ReportQuery
        def self.add_select_clause(query, data_source, report_config)
          fields = []
          report_config['columns'].each do |column|
            next unless column['selected']

            if report_config['aggregated']
              fields << column['name'] if column['group_by']
              fields << "COUNT(#{column['name']}) AS 'num_#{column['name']}'" if column['count']
              if column['count_distinct']
                fields << "COUNT(DISTINCT #{column['name']}) AS 'num_uniq_#{column['name']}'"
              end
              if column['average']
                if column['type'].in?(%w[date datetime])
                  fields << "FROM_UNIXTIME(AVG(UNIX_TIMESTAMP(#{column['name']}))) AS 'avg_#{column['name']}'"
                else
                  fields << "AVG(#{column['name']}) AS 'avg_#{column['name']}'"
                end
              end
              fields << "MIN(#{column['name']}) AS 'min_#{column['name']}'" if column['min']
              fields << "MAX(#{column['name']}) AS 'max_#{column['name']}'" if column['max']
              fields << "SUM(#{column['name']}) AS 'sum_#{column['name']}'" if column['sum']
            else
              fields << column['name']
            end
          end

          fields = data_source.column_names if fields.empty?

          query.select(fields)
        end

        def self.add_where_clause(query, report_config)
          return query if report_config['filters'].blank?

          report_config['filters'].each do |filter|
            field = filter['name']
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

        def self.add_group_clause(query, report_config)
          return query unless report_config['aggregated']

          group_fields = []
          report_config['columns'].each do |column|
            next unless column['selected'] && column['group_by']

            group_fields << column['name']
          end

          query.group(group_fields)
        end
      end
    end
  end
end
