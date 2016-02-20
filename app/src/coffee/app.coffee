$ ->

  # DOM Elements
  $window = $(window)
  $device = $('.device')
  $sectionContent = $('.home .section-content')

  resizeHandler = ->
    setWindowSize()
    setDevicePosition()

  setWindowSize = ->
    App.windowHeight = $window.height()
    App.windowWidth = $window.width()

  setDevicePosition = ->
    App.posTop = posTop = $sectionContent.offset().top
    $device.css 'top', posTop

  # Events
  $window
    .on 'resize', resizeHandler
    .trigger 'resize', resizeHandler
