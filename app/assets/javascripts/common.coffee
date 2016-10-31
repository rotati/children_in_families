CIF.Common =
  init: ->
    @hideNotification()
    @hideDynamicOperator()
    @menuDropDownClick()
    @validateFilterNumber()
    @customCheckBox()
    @initNotification()

  hideNotification: ->
    notice = $('p#notice')
    if notice
      setTimeout (->
        $(notice).fadeOut()
      ), 5000

  customCheckBox: ->
    $('.i-checks').iCheck
      checkboxClass: 'icheckbox_square-green'

  menuDropDownClick: ->
    $('#side-menu').metisMenu()

  hideDynamicOperator: ->
    $('.dynamic_filter').find('option[value="=~"]').remove('option')

  validateFilterNumber: ->
    $(window).load ->
      $('input[type="number"]').attr('min','0')

  initNotification: ->
    messageOption = {
      "closeButton": true,
      "debug": true,
      "progressBar": true,
      "positionClass": "toast-top-center",
      "showDuration": "400",
      "hideDuration": "1000",
      "timeOut": "7000",
      "extendedTimeOut": "1000",
      "showEasing": "swing",
      "hideEasing": "linear",
      "showMethod": "fadeIn",
      "hideMethod": "fadeOut"
    }
    messageInfo = $("#wrapper").data()
    if Object.keys(messageInfo).length > 0
      console.log messageInfo.messageType
      if messageInfo.messageType == 'notice'
        toastr.success(messageInfo.message, 'Notification', messageOption)
      else if messageInfo.messageType == 'alert'
        toastr.error(messageInfo.message, 'Notification', messageOption)
      #
      # else if
      #   toastr.error(messageInfo.message, 'Notification', messageOption)
