class App.Video
  constructor: ->
    @order = 21

  build: (exports) ->
    exports.VideoController = @
    exports.controllers.push @

    @init exports

  init: (exports) ->
    # DOM Elements
    @$video = $('.video')
    console.log 'init video'
    @$video[0].addEventListener("ended", @reverseVideo) #.on 'ended', @reverseVideo exports

  reverseVideo: (exports) =>
    console.log 'video has ended'
    @$video[0].playbackRate = -1

  onResize: (exports) ->

  onScroll: (exports, scrollY) ->

App.FXs.push new App.Video
