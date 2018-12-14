module AdvancedSearches
  class CsiFields
    extend AdvancedSearchHelper

    def self.render
      csi_group  = format_header('custom_csi_group')
      csi_domain_options  = number_type_list.map { |item| number_filter_type(item, format_header(item), csi_group) }
      date_of_assessments = ['Date of Assessments'].map{ |item| date_picker_options(item.downcase.gsub(' ', '_'), item, csi_group) }
      
      (date_of_assessments + csi_domain_options).sort_by { |f| f[:label].downcase }
    end

    private

    def self.number_type_list
      ['assessment_number', 'month_number']
    end

    def self.domain_options
      Domain.order_by_identity.map { |domain| "domainscore_#{domain.id}_#{domain.identity}" }
    end

    def self.domain_score_format(label)
      label.split('_').last
    end

    def self.date_picker_options(field_name, label, group)
      {
        id: field_name,
        optgroup: group,
        label: label,
        type: 'date',
        # operators: ['equal', 'not_equal', 'less', 'less_or_equal', 'greater', 'greater_or_equal', 'between', 'is_empty', 'is_not_empty'],
        operators: ['equal', 'between'],
        plugin: 'datepicker',
        plugin_config: {
          format: 'yyyy-mm-dd',
          todayBtn: 'linked',
          todayHighlight: true,
          autoclose: true
        }
      }
    end

    def self.number_filter_type(field_name, label, group)
      {
        id: field_name,
        optgroup: group,
        label: label,
        type: 'integer',
        operators: ['equal']
      }
    end
  end
end
