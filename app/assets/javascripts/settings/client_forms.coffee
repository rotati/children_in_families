CIF.SettingsClient_forms = do ->
  _init = ->
    _initICheckBox()

  _initICheckBox = ->
    $('.i-checks').iCheck
      checkboxClass: 'icheckbox_square-green'
      radioClass: 'iradio_square-green'
  { init: _init }
