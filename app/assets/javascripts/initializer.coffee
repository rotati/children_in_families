CIF.Initializer =
  exec: (pageName) ->
    if pageName && CIF[pageName]
      CIF[pageName]['init']()

  currentPage: ->
    return '' unless $('body').attr('id')

    bodyId      = $('body').attr('id').split('-')
    action      = CIF.Util.capitalize(bodyId[1])
    controller  = CIF.Util.capitalize(bodyId[0])
    controller + action

  init: ->
    try
      CIF.Initializer.exec('Common')
      if @currentPage()
        CIF.Initializer.exec(@currentPage())
    catch error
      appsignal.sendError error


$(document).on 'ready page:load', ->
  CIF.Initializer.init()
