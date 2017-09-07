module AdvancedSearches
  class ClientHistoryAssociationFilter
    def initialize(clients, field, operator, values, history_date)
      # @clients  = clients
      @field    = field
      @operator = operator
      @value   = values
      @history_date = history_date

      @client_ids = []
      start_date = @history_date[:start_date].to_date.beginning_of_day
      end_date = @history_date[:end_date].to_date.end_of_day
      @clients = ClientHistory.where(created_at: start_date..end_date)
    end

    def get_sql
      client_ids = []
      case @field
      # when 'placement_date'
      #   values = placement_date_field_query
      # when 'form_title'
      #   values = form_title_field_query
      when 'case_type'
        case_type_field_query
      when 'user_id'
        user_id_field_query
      when 'agency_name'
        agency_name_field_query
      when 'family_id'
        family_id_field_query
      when 'family'
        family_name_field_query
      when 'age'
        age_field_query
      when 'referred_to_ec'
        program_placement_date_field_query('EC')
      when 'referred_to_fc'
        program_placement_date_field_query('FC')
      when 'referred_to_kc'
        program_placement_date_field_query('KC')
      # when 'exit_ec_date'
      #   values = program_exit_date_field_query('EC')
      # when 'exit_fc_date'
      #   values = program_exit_date_field_query('FC')
      # when 'exit_kc_date'
      #   values = program_exit_date_field_query('KC')
      # when 'program_stream'
      #   values = program_stream_query
      end
      sql_string = { 'object.id': { '$in': @client_ids.flatten.uniq }}
    end

    private

    # def program_stream_query
    #   clients = @clients.joins(:client_enrollments).where(client_enrollments: { status: 'Active' })
    #   case @operator
    #   when 'equal'
    #     clients.where('client_enrollments.program_stream_id = ?', @value ).ids
    #   when 'not_equal'
    #     clients.where.not('client_enrollments.program_stream_id = ?', @value ).ids
    #   when 'is_empty'
    #     @clients.where.not(id: clients.ids).ids
    #   when 'is_not_empty'
    #     @clients.where(id: clients.ids).ids
    #   end
    # end

    # def placement_date_field_query
    #   # clients = @clients.joins(:cases)

    #   client_ids = []
    #   start_date = @history_date[:start_date].to_date.beginning_of_day
    #   end_date = @history_date[:end_date].to_date.end_of_day

    #   clients = ClientHistory.where('$and': [{ created_at: start_date..end_date}, { 'object.case_ids': { '$ne': nil } }])

    #   start_date_value = @value.try(:to_date).try(:beginning_of_day)
    #   end_date_value = @value.try(:to_date).try(:end_of_day)

    #   case @operator
    #   when 'equal'
    #     # clients = clients.where(cases: { start_date: @value })
    #     clients.each do |ch|
    #       case_clients = ch.cases.where('object.start_date': start_date_value).distinct('object.id')
    #     end
    #   when 'not_equal'
    #     clients = clients.where("cases.start_date != ? OR cases.start_date IS NULL", @value)
    #   when 'less'
    #     clients = clients.where('cases.start_date < ?', @value)
    #   when 'less_or_equal'
    #     clients = clients.where('cases.start_date <= ?', @value)
    #   when 'greater'
    #     clients = clients.where('cases.start_date > ?', @value)
    #   when 'greater_or_equal'
    #     clients = clients.where('cases.start_date >= ?', @value)
    #   when 'between'
    #     clients = clients.where(cases: { start_date: @value[0]..@value[1] })
    #   when 'is_empty'
    #     ids = @clients.where.not(id: clients.ids).ids
    #   when 'is_not_empty'
    #     ids = @clients.where(id: clients.ids).ids
    #   end

    #   if @operator != 'is_empty'
    #     sub_query = 'SELECT MAX(cases.created_at) FROM cases WHERE cases.client_id = clients.id'
    #     ids = clients.where("cases.created_at = (#{sub_query})").ids
    #   end
    #   client_ids
    # end

    # def form_title_field_query
    #   clients = @clients.joins(:custom_fields)
    #   case @operator
    #   when 'equal'
    #     clients = clients.where('custom_fields.id = ?', @value)
    #   when 'not_equal'
    #     clients = clients.where.not('custom_fields.id = ?', @value)
    #   when 'is_empty'
    #     clients = @clients.where.not(id: clients.ids)
    #   when 'is_not_empty'
    #     clients = @clients.where(id: clients.ids)
    #   end
    #   clients.uniq.ids
    # end

    def case_type_field_query
      case_type_clients = @clients.where('object.case_ids': { '$ne': nil })
      case @operator
      when 'equal'
        case_type_clients.each do |ch|
          case_clients = ch.case_client_histories.where('$and': [{ 'object.case_type': @value }, {'object.exited': false}])
          next if case_clients.empty?

          @client_ids << case_clients.map {|a| a.object['client_id']}.uniq
        end
      when 'not_equal'
        case_type_clients.each do |ch|
          case_clients = ch.case_client_histories.where('object.case_type': { '$ne': @value })
          next if case_clients.empty?

          @client_ids << case_clients.map {|a| a.object['client_id']}.uniq
        end
      when 'is_empty'
        clients = @clients.where('object.case_ids': nil)
        @client_ids << clients.map {|a| a.object['id']}.uniq
      when 'is_not_empty'
        @client_ids << case_type_clients.map {|a| a.object['id']}.uniq
      end
    end

    def agency_name_field_query
      agency_clients = @clients.where('object.agency_ids': { '$ne': nil })
      case @operator
      when 'equal'
        clients = agency_clients.where('object.agency_ids': @value.to_i)
      when 'not_equal'
        clients = agency_clients.where('object.agency_ids': { '$ne': @value.to_i })
      when 'is_empty'
        clients = @clients.where('object.agency_ids': nil)
      when 'is_not_empty'
        clients = agency_clients
      end
      @client_ids << clients.map {|a| a.object['id']}.uniq
    end

    def user_id_field_query
      user_clients = @clients.where('object.user_ids': { '$ne': nil })
      case @operator
      when 'equal'
        clients = user_clients.where('object.user_ids': { '$in': [@value.to_i] })
      when 'not_equal'
        clients = user_clients.where('object.user_ids': { '$nin': [@value.to_i] })
      when 'is_empty'
        clients = @clients.where('object.user_ids': nil)
      when 'is_not_empty'
        clients = user_clients
      end
      @client_ids << clients.map {|a| a.object['id']}.uniq
    end

    def family_id_field_query
      @values = validate_family_id(@value)
      family_clients = @clients.where('object.family_ids': { '$ne': nil })
      case @operator
      when 'equal'
        clients = family_clients.where('object.family_ids': { '$in': [@values.to_i] })
      when 'not_equal'
        clients = family_clients.where('object.family_ids': { '$nin': [@values.to_i] })
      when 'less'
        clients = family_clients.where('object.family_ids': { '$lt': @values.to_i })
      when 'less_or_equal'
        clients = family_clients.where('object.family_ids': { '$lte': @values.to_i })
      when 'greater'
        clients = family_clients.where('object.family_ids': { '$gt': @values.to_i })
      when 'greater_or_equal'
        clients = family_clients.where('object.family_ids': { '$gte': @values.to_i })
      when 'between'
        clients = family_clients.where('object.family_ids': @values[0].to_i..@values[1].to_i)
      when 'is_empty'
        non_family_clients = @clients.where('object.family_ids': nil)
        clients = non_family_clients
      when 'is_not_empty'
        clients = family_clients
      end
      @client_ids << clients.map {|a| a.object['id']}.uniq
    end

    def family_name_field_query
      family_clients = @clients.where('object.family_ids': { '$ne': nil })

      case @operator
      when 'equal'
        family_clients.each do |c|
          clients = c.client_family_histories.where('object.name': @value)

          @client_ids << c.object['id'] if clients.any?
        end
      when 'not_equal'
        family_clients.each do |c|
          clients = c.client_family_histories.where('object.name': { '$ne': @value })

          @client_ids << c.object['id'] if clients.any?
        end
      when 'contains'
        family_clients.each do |c|
          clients = c.client_family_histories.where('object.name': /.*#{@value}.*/i)

          @client_ids << c.object['id'] if clients.any?
        end
      when 'not_contains'
        family_clients.each do |c|
          clients = c.client_family_histories.where('object.name': { '$not': /.*#{@value}.*/i })

          @client_ids << c.object['id'] if clients.any?
        end
      when 'is_empty'
        clients = @clients.where('object.family_ids': nil)
        @client_ids << clients.map { |client| client.object['id'] }.uniq
      when 'is_not_empty'
        clients = family_clients
        @client_ids << clients.map { |client| client.object['id'] }.uniq
      end
    end

    def age_field_query
      date_value_format = convert_age_to_date(@value)

      case @operator
      when 'equal'
        clients = @clients.where('object.date_of_birth': date_value_format)
      when 'not_equal'
        clients = @clients.where('object.date_of_birth': { '$ne': date_value_format })
      when 'less'
        clients = @clients.where('object.date_of_birth': { '$gt': date_value_format })
      when 'less_or_equal'
        clients = @clients.where('object.date_of_birth': { '$gte': date_value_format })
      when 'greater'
        clients = @clients.where('object.date_of_birth': { '$lt': date_value_format })
      when 'greater_or_equal'
        clients = @clients.where('object.date_of_birth': { '$lte': date_value_format })
      when 'between'
        clients = @clients.where('object.date_of_birth': date_value_format[0]..date_value_format[1])
      when 'is_empty'
        clients = @clients.where('object.date_of_birth': nil)
      when 'is_not_empty'
        clients = @clients.where('object.date_of_birth': { '$ne': nil })
      end
      @client_ids << clients.map {|a| a.object['id']}.uniq
    end

    def convert_age_to_date(value)
      overdue_year = 999.years.ago.to_date
      if value.is_a?(Array)
        min_age = (value[0].to_i * 12).months.ago.to_date
        max_age = (value[1].to_i * 12).months.ago.to_date
        min_age = min_age > overdue_year ? min_age : overdue_year
        max_age = max_age > overdue_year ? max_age : overdue_year
        [max_age, min_age]
      else
        age = (value.to_i * 12).months.ago.to_date
        age > overdue_year ? age : overdue_year
      end
    end

    def validate_family_id(ids)
      if ids.is_a?(Array)
        first_value = ids.first.to_i > 1000000 ? "1000000" : ids.first
        last_value  = ids.last.to_i > 1000000 ? "1000000" : ids.last
        [first_value, last_value]
      else
        ids.to_i > 1000000 ? "1000000" : ids
      end
    end

    def program_placement_date_field_query(case_type)
      clients = @clients.where('object.case_ids': { '$ne': nil })
      start_date_value = @value.try(:to_date).try(:beginning_of_day)
      end_date_value = @value.try(:to_date).try(:end_of_day)

      case @operator
      when 'equal'
        clients.each do |ch|
          case_client_histories = ch.case_client_histories.where('$and': [{ 'object.case_type': case_type }, { 'object.start_date': start_date_value..end_date_value }])
          next if case_client_histories.empty?

          @client_ids << case_client_histories.map {|a| a.object['client_id']}
        end
      when 'not_equal'
        clients.each do |ch| 
          case_client_histories = ch.case_client_histories.where('$and': [{ 'object.case_type': case_type }, { 'object.start_date': { '$ne': start_date_value } }])
          next if case_client_histories.empty?

          @client_ids << case_client_histories.map {|a| a.object['client_id']}
        end
      when 'less'
        clients.each do |ch| 
          case_client_histories = ch.case_client_histories.where('$and': [{ 'object.case_type': case_type }, { 'object.start_date': { '$lt': start_date_value } }])
          next if case_client_histories.empty?

          @client_ids << case_client_histories.map {|a| a.object['client_id']}
        end
      when 'less_or_equal'
        clients.each do |ch| 
          case_client_histories = ch.case_client_histories.where('$and': [{ 'object.case_type': case_type }, { 'object.start_date': { '$lte': start_date_value } }])
          next if case_client_histories.empty?

          @client_ids << case_client_histories.map {|a| a.object['client_id']}
        end
      when 'greater'
        clients.each do |ch| 
          case_client_histories = ch.case_client_histories.where('$and': [{ 'object.case_type': case_type }, { 'object.start_date': { '$gt': start_date_value } }])
          next if case_client_histories.empty?

          @client_ids << case_client_histories.map {|a| a.object['client_id']}
        end
      when 'greater_or_equal'
        clients.each do |ch| 
          case_client_histories = ch.case_client_histories.where('$and': [{ 'object.case_type': case_type }, { 'object.start_date': { '$gte': start_date_value } }])
          next if case_client_histories.empty?

          @client_ids << case_client_histories.map {|a| a.object['client_id']}
        end
      when 'between'
        clients.each do |ch| 
          case_client_histories = ch.case_client_histories.where('$and': [{ 'object.case_type': case_type }, { 'object.start_date': @value.first..@value.last  }])
          next if case_client_histories.empty?

          @client_ids << case_client_histories.map {|a| a.object['client_id']}
        end
      when 'is_empty'
        clients = @clients.where('object.case_ids': nil).map {|a| a.object['id']}

        @client_ids << clients
      when 'is_not_empty'
        clients.each do |ch| 
          case_client_histories = ch.case_client_histories.where('object.case_type': case_type)
          next if case_client_histories.empty?

          @client_ids << case_client_histories.map {|a| a.object['client_id']}
        end
      end
      @client_ids.flatten.uniq
    end

  #   def program_exit_date_field_query(case_type)
  #     clients = @clients.joins(:cases).where(cases: { exited: true })

  #     case @operator
  #     when 'equal'
  #       clients = clients.where(cases: { case_type: case_type, exit_date: @value })
  #     when 'not_equal'
  #       clients = clients.where("cases.case_type = ? AND cases.exit_date != ?", case_type, @value)
  #     when 'less'
  #       clients = clients.where('cases.case_type = ? AND cases.exit_date < ?', case_type, @value)
  #     when 'less_or_equal'
  #       clients = clients.where('cases.case_type = ? AND cases.exit_date <= ?', case_type, @value)
  #     when 'greater'
  #       clients = clients.where('cases.case_type = ? AND cases.exit_date > ?', case_type, @value)
  #     when 'greater_or_equal'
  #       clients = clients.where('cases.case_type = ? AND cases.exit_date >= ?', case_type, @value)
  #     when 'between'
  #       clients = clients.where(cases: { case_type: case_type, exit_date: @value[0]..@value[1] })
  #     when 'is_empty'
  #       clients = @clients.includes(:cases).where('cases.exited = ? OR cases.id IS NULL', false)
  #     when 'is_not_empty'
  #       clients = @clients.includes(:cases).where.not('cases.exited = ? OR cases.id IS NULL', false)
  #     end
  #     clients.ids.uniq
  #   end
  end
end
