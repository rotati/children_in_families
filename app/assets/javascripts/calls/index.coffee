CIF.CallsIndex = do ->
  _init = ->
    _initAdavanceSearchFilter()
    _setAdavanceSearchFilter()

  _initAdavanceSearchFilter = ->
    $.fn.queryBuilder.define 'select2', ((options) ->
      if !$.fn.select2 or !$.fn.select2.constructor
        Utils.error 'MissingLibrary', 'Select2 is required'
      Selectors = $(".rule-operator-container [name$=_operator], .rule-filter-container [name$=_filter]")
      if Selectors
        @on 'afterCreateRuleFilters', (e, rule) ->
          rule.$el.find(".rule-filter-container [name$=_filter]").select2 options
          return
        @on 'afterCreateRuleOperators', (e, rule) ->
          rule.$el.find(".rule-operator-container [name$=_operator]").select2 options
          return
        @on 'afterUpdateRuleFilter', (e, rule) ->
          rule.$el.find(".rule-filter-container [name$=_filter]").select2 options
          return
        @on 'afterUpdateRuleOperator', (e, rule) ->
          rule.$el.find(".rule-operator-container [name$=_operator]").select2 options
          return
        @on 'beforeDeleteRule', (e, rule) ->
          rule.$el.find(".rule-filter-container [name$=_filter]").select2 'destroy'
          rule.$el.find(".rule-operator-container [name$=_operator]").select2 'destroy'
          return
      return
    ),
      container: 'body'
      style: 'btn-inverse btn-xs'
      width: '250px'
      showIcon: false

    filters = $("#call-builder-fields").data('fields')

    $('#builder').queryBuilder
      plugins: [
        'select2'
      ]
      filters: filters
      lang_code: 'en'

    $('#call-advanced-search').on 'submit', (e) ->
      query = $('#builder').queryBuilder('getRules')
      if query
        $('#query_builder_json').val JSON.stringify(query)
      else
        e.preventDefault()
        $('#query_builder_json').val null
      return

  _setAdavanceSearchFilter = ->
    queryJson = $('#builder').data('basic-search-rules')
    $('#builder').queryBuilder 'setRules', queryJson if queryJson

  _getCallPath = ->
    return if $('table.calls tbody tr').text().trim() == 'No results found' || $('table.clients tbody tr').text().trim() == 'មិនមានលទ្ធផល' || $('table.clients tbody tr').text().trim() == 'No data available in table'
    $('table.calls tbody tr').click (e) ->
      return if $(e.target).hasClass('btn') || $(e.target).hasClass('fa') || $(e.target).is('a')
      window.open($(@).data('href'), '_blank')
    return

  { init: _init }
