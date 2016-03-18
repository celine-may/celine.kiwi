class Renderer
  constructor: (options) ->
    @$window = $(window)

    @exports = {}

    @fxs = options.fxs || []

  init: ->
    exports = @exports =
      path: App.path
      isTouch: Modernizr.touchevents
      controllers: []
      windowWidth: @$window.width()
      windowHeight: @$window.height()
      isSmall: @$window.width() <= 767
      isMedium: 767 < @$window.width() <= 1023
      smallBreakpoint: 767
      mediumBreakpoint: 1023
      deviceSize: 196
      deviceBorder: 16
      overlaySize: 604
      gap: 22
      primaryColor: '#125e72'
      secondaryColor: '#7dffe3'

    fxs = @fxs
    fxs.sort (a, b) ->
      a.order - b.order

    for fx in fxs
      fx.build exports

    window.addEventListener 'resize', @resize.bind @
    @resize()

  resize: (e) ->
    exports = @exports
    windowWidth = exports.windowWidth = @$window.width()
    exports.windowHeight = @$window.height()

    if windowWidth <= exports.smallBreakpoint
      exports.isSmall = true
      exports.deviceSize = 96
      exports.deviceBorder = 10
    else
      exports.isSmall = false
      exports.deviceSize = 196
      exports.deviceBorder = 16

    if exports.smallBreakpoint < windowWidth <= exports.mediumBreakpoint
      exports.isMedium = true
    else
      isMedium = false

    for fx in @fxs
      fx.resize exports

App.Renderer = Renderer
