module AdvancedSearches
  class TrackingSqlBuilder

    def initialize(tracking_id, rule)
      @tracking_id = tracking_id
      field     = rule['field']
      @field    = field.split('_').last.gsub("'", "''")
      @operator = rule['operator']
      @value    = format_value(rule['value'])
      @type     = rule['type']
    end

    def get_sql
      sql_string = 'clients.id IN (?)'
      properties_field = 'client_enrollment_trackings.properties'
      client_enrollment_trackings = ClientEnrollmentTracking.joins(:client_enrollment).where(client_enrollments: { status: 'Active' }, tracking_id: @tracking_id)

      case @operator
      when 'equal'
        properties_result = client_enrollment_trackings.where("#{properties_field} -> '#{@field}' ? '#{@value}' ")
      when 'not_equal'
        properties_result = client_enrollment_trackings.where.not("#{properties_field} -> '#{@field}' ? '#{@value}' ")
      when 'less'
        properties_result = client_enrollment_trackings.where("(#{properties_field} ->> '#{@field}')#{'::int' if integer? } < '#{@value}' AND #{properties_field} ->> '#{@field}' != '' ")
      when 'less_or_equal'
        properties_result = client_enrollment_trackings.where("(#{properties_field} ->> '#{@field}')#{ '::int' if integer? } <= '#{@value}' AND #{properties_field} ->> '#{@field}' != '' ")
      when 'greater'
        properties_result = client_enrollment_trackings.where("(#{properties_field} ->> '#{@field}')#{ '::int' if integer? } > '#{@value}' AND #{properties_field} ->> '#{@field}' != '' ")
      when 'greater_or_equal'
        properties_result = client_enrollment_trackings.where("(#{properties_field} ->> '#{@field}')#{ '::int' if integer? } >= '#{@value}' AND #{properties_field} ->> '#{@field}' != '' ")
      when 'contains'
        properties_result = client_enrollment_trackings.where("#{properties_field} ->> '#{@field}' ILIKE '%#{@value}%' ")
      when 'not_contains'
        properties_result = client_enrollment_trackings.where("#{properties_field} ->> '#{@field}' NOT ILIKE '%#{@value}%' ")
      when 'is_empty'
        properties_result = client_enrollment_trackings.where("#{properties_field} -> '#{@field}' ? '' ")
      when 'between'
        properties_result = client_enrollment_trackings.where("(#{properties_field} ->> '#{@field}')#{ '::int' if integer? } BETWEEN '#{@value.first}' AND '#{@value.last}' AND #{properties_field} ->> '#{@field}' != ''")
      end
      client_ids = properties_result.pluck('client_enrollments.client_id').uniq
      {id: sql_string, values: client_ids}
    end

    private
    def integer?
      @type == 'integer'
    end

    def format_value(value)
      value.is_a?(Array) ? value : value.gsub("'", "''")
    end
  end
end
