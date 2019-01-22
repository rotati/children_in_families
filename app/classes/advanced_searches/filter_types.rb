module AdvancedSearches
  class FilterTypes
    def self.text_options(field_name, label, group)
      {
        id: field_name,
        field: label,
        optgroup: group,
        label: label,
        type: 'string',
        operators: ['equal', 'not_equal', 'contains', 'not_contains', 'is_empty', 'is_not_empty']
      }
    end

    def self.number_options(field_name, label, group)
      {
        id: field_name,
        field: label,
        optgroup: group,
        label: label,
        type: 'integer',
        operators: ['equal', 'not_equal', 'less', 'less_or_equal', 'greater', 'greater_or_equal', 'between', 'is_empty', 'is_not_empty']
      }
    end

    def self.date_picker_options(field_name, label, group)
      {
        id: field_name,
        field: label,
        optgroup: group,
        label: label,
        type: 'date',
        operators: ['equal', 'not_equal', 'less', 'less_or_equal', 'greater', 'greater_or_equal', 'between', 'is_empty', 'is_not_empty'],
        plugin: 'datepicker',
        plugin_config: {
          format: 'yyyy-mm-dd',
          todayBtn: 'linked',
          todayHighlight: true,
          autoclose: true
        }
      }
    end

    def self.drop_list_options(field_name, label, values, group)
      {
        id: field_name,
        field: label,
        optgroup: group,
        label: label,
        type: 'string',
        input: 'select',
        values: values,
        data: { values: format_data(field_name, values), isAssociation: is_association?(field_name, values)},
        operators: ['equal', 'not_equal', 'is_empty', 'is_not_empty']
      }
    end

    def self.has_this_form_drop_list_options(field_name, label, values, group)
      {
        id: field_name,
        field: label,
        optgroup: group,
        label: label,
        input: 'select',
        values: values,
        data: { values: format_data(field_name, values), isAssociation: false },
        operators: ['equal']
      }
    end

    def self.format_data(field_name, values)
      data = []
      case field_name
      when 'birth_province_id'
        values.each do |value|
          data << {value[:value] => value[:label]}
        end
      when 'gender', 'has_been_in_orphanage', 'has_been_in_government_care'
        data = values.map{ |key, value| { key => value } }
      else
        data = values
      end
      data
    end

    def self.is_association?(field, values)
      begin
        values.each do |value|
          next if Integer value.keys[0]
        end
        return is_association = true
      rescue
        special_case_fields = ['birth_province_id', 'gender', 'has_been_in_orphanage', 'has_been_in_government_care']
        return is_association = true if field.in? special_case_fields
        return is_association = false
      end
    end
  end
end
