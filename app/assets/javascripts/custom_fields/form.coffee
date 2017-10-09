CIF.Custom_fieldsNew = CIF.Custom_fieldsCreate = CIF.Custom_fieldsEdit = CIF.Custom_fieldsUpdate = do ->
  @customFieldId = $('#custom_field_id').val()
  FIELDS_URL = "/api/custom_fields/#{@customFieldId}/fields"
  CUSTOM_FIELDS_URL = '/api/custom_fields/fetch_custom_fields'
  _init = ->
    _initFormBuilder()
    _retrieveData(FIELDS_URL) if $('#custom_field_id').val() != ''
    _retrieveData(CUSTOM_FIELDS_URL) if $('#custom_field_form_title').attr('disabled') != 'disabled'
    _select2()
    _toggleTimeOfFrequency()
    _changeSelectOfFrequency()
    _valTimeOfFrequency()
    _changeTimeOfFrequency()
    _convertFrequency()
    _removeSearchCustomFields()

  _valTimeOfFrequency = ->
    $('#custom_field_time_of_frequency').val()

  timeOfFrequency = parseInt(_valTimeOfFrequency())

  _toggleTimeOfFrequency = ->
    frequency = _convertFrequency()
    if frequency == ''
      $('#custom_field_time_of_frequency').attr('readonly', 'true')
        .val(0)
      $('.frequency-note').addClass('hidden')
    else
      if timeOfFrequency == 0
        timeOfFrequency = 1
      $('#custom_field_time_of_frequency').removeAttr('readonly')
        .val(parseInt(timeOfFrequency))

      _updateFrequencyNote(frequency, timeOfFrequency)

  _changeTimeOfFrequency = ->
    $('#custom_field_time_of_frequency').change ->
      if $(this).val() == ''
        $(this).val(1)
      frequency = _convertFrequency()
      _updateFrequencyNote(frequency, parseInt($(this).val()))

  _updateFrequencyNote = (frequency, timeOfFrequency) ->
    if timeOfFrequency <= 0
      $('.frequency-note').addClass('hidden')
    else
      $('.frequency-note').removeClass('hidden')
      if timeOfFrequency == 1
        $('.frequency-note span.frequency').text(" #{frequency}.")
      else
        $('.frequency-note span.frequency').text(" #{timeOfFrequency} #{frequency}s.")

  _changeSelectOfFrequency = ->
    $('#custom_field_frequency').change ->
      _toggleTimeOfFrequency()

  _convertFrequency = ->
    frequency = $('#custom_field_frequency').val()
    switch(frequency)
      when 'Daily'
        frequency = 'day'
      when 'Weekly'
        frequency = 'week'
      when 'Monthly'
        frequency = 'month'
      when 'Yearly'
        frequency = 'year'
      else
        frequency = ''

  _initFormBuilder = ->
    builderOption = new CIF.CustomFormBuilder()
    fields = $('.build-wrap').data('fields') || []
    breakLine = [ {
      label: 'Separate Line'
      attrs: type: 'separateLine'
      icon: '<i class="fa fa-minus" aria-hidden="true"></i>'
    } ]

    formBuilder = $('.build-wrap').formBuilder
      templates: separateLine: (fieldData) ->
        { field: '<hr/>' }
      fields: builderOption.thematicBreak()
      dataType: 'json'
      formData:  JSON.stringify(fields)
      disableFields: ['autocomplete', 'header', 'hidden', 'paragraph', 'button', 'checkbox']
      showActionButtons: false
      messages: {
        cannotBeEmpty: 'name_separated_with_underscore'
      }
      stickyControls: {
        enable: true
        offset:
          top: 20,
          right: 20,
          left: 'auto'
      }

      typeUserEvents: {
        'checkbox-group': builderOption.eventCheckboxOption()
        date: builderOption.eventDateOption()
        file: builderOption.eventFileOption()
        number: builderOption.eventNumberOption()
        'radio-group': builderOption.eventRadioOption()
        select: builderOption.eventSelectOption()
        text: builderOption.eventTextFieldOption()
        textarea: builderOption.eventTextAreaOption()
        separateLine: builderOption.eventSeparateLineOption()
      }

    $("#custom-field-submit").click (event) ->
      specialCharacters = {"&quot;": '"', "&amp;": "&", "&lt;": "<", "&gt;": ">"}
      $('#custom_field_fields').val(formBuilder.actions.save().allReplace(specialCharacters))

  _select2 = ->
    $('#custom_field_entity_type').select2
      minimumInputLength: 0
    $('#custom_field_frequency').select2
      minimumInputLength: 0
      allowClear: true

  _retrieveData = (url) ->
    $.ajax
      method: 'GET'
      url: url
      dataType: 'JSON'
      success: (response) ->
        _preventRemoveFields(response.fields) if response.hasOwnProperty('fields')
        _searchCustomFields(response.custom_fields) if response.hasOwnProperty('custom_fields')

  _searchCustomFields = (fields) ->
    $('#custom_field_form_title').keyup ->
      $('#livesearch').css('visibility', 'hidden')
      $('#livesearch').empty()
      form_title = $('#custom_field_form_title').val()
      if form_title != ''
        for field in fields
          if field.form_title.toLowerCase().startsWith(form_title.toLowerCase())
            previewTranslation = $('#livesearch').data('preview-translation')
            copyTranslation = $('#livesearch').data('copy-translation')
            width = $('#custom_field_form_title').css('width')
            $('#livesearch').css('width', width)
            $('#livesearch').css('visibility', 'visible')
            ngo_name = field.ngo_name.replace(/\s/g,"+")
            url_origin = document.location.origin
            preview_link = "#{url_origin}/custom_fields/preview?custom_field_id=#{field.id}&ngo_name=#{ngo_name}"
            $('#livesearch').append("<li><span class='col-xs-8'>#{field.form_title} (#{field.ngo_name})</span>
            <span class='col-xs-4 text-right'><a href=#{preview_link}>#{previewTranslation}</a></span></li>")

  _removeSearchCustomFields = ->
    $('#custom_field_form_title').blur ->
      $('#livesearch').css('visibility', 'hidden')

  _preventRemoveFields = (fields) ->
    labelFields = $('label.field-label')
    for labelField in labelFields
      parent = $(labelField).parent()
      text = labelField.textContent
      $(parent).children('div.field-actions').remove() if fields.includes(text)

  { init: _init }
