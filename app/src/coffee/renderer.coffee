class Renderer
  constructor: (options) ->
    @$window = $(window)

    @exports = {}

    @fxs = options.fxs || []

  init: ->
    exports = @exports =
      path: App.path
      section: 'home'
      windowWidth: @$window.width()
      windowHeight: @$window.height()
      deviceSize: 196
      deviceBorder: 16
      overlaySize: 604
      gap: 22
      primaryColor: '#125e72'
      secondaryColor: '#7dffe3'
      controllers: []
    fxs = @fxs
    fxs.sort (a, b) ->
      a.order - b.order

    for fx in fxs
      fx.build exports

    window.addEventListener 'resize', @resize.bind @
    @resize()

  resize: (e) ->
    exports = @exports
    exports.windowWidth = @$window.width()
    exports.windowHeight = @$window.height()
    for fx in @fxs
      fx.resize exports

App.Renderer = Renderer
