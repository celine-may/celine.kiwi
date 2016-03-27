class Renderer
  constructor: (options) ->
    @$window = $(window)

    @exports = {}
    @fxs = options.fxs || []

    @lastScrollY = 0
    @ticking = false

  init: ->
    exports = @exports =
      path: App.path
      isTouch: Modernizr.touchevents
      controllers: []
      activeSection: 'home'
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

    exports.RendererController = @

    fxs = @fxs
    fxs.sort (a, b) ->
      a.order - b.order

    for fx in fxs
      fx.build exports

    @$window
      .on 'resize', @onResize.bind @
      .trigger 'resize'
      .on 'scroll', @onScroll.bind @

  onResize: (e) ->
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
      fx.onResize exports

  scrollTween: (exports, startPoint, endPoint, tweenName, scrollY, timelinePosition) ->
    unless tweenName?
      return
    progressValue = (1 / (endPoint - startPoint)) * (scrollY - startPoint)

    if 0 <= progressValue <= 1
      tweenName.progress progressValue
      exports.currentProgressValue = progressValue + timelinePosition
    else if progressValue < 0
      tweenName.progress 0
    else if progressValue > 1
      tweenName.progress 1

  onScroll: (e) ->
    exports = @exports
    @lastScrollY = window.scrollY
    if not @ticking
      window.requestAnimationFrame =>
        for fx in @fxs
          fx.onScroll exports, @lastScrollY
        @ticking = false
    @ticking = true

App.Renderer = Renderer
