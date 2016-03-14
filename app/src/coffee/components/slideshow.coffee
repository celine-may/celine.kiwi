class App.Slideshow
  constructor: ->
    @order = 2

  build: (exports) ->
    exports.SlideshowController = @
    exports.controllers.push @

    @init exports

  init: (exports) ->
    # DOM Elements
    @$slideshow = $('.slideshow')
    @$slides = @$slideshow.find '.slide'

    @$slideshowPrevLink = $('.do-slideshow-prev')
    @$slideshowNextLink = $('.do-slideshow-next')

    # Variables
    @slidesCount = @$slides.length
    @activeSlide = parseInt(@$slideshow.find('.slide.init').attr('data-slide'))

    # Events
    @$slideshowPrevLink.on 'click', (e) =>
      e.preventDefault()
      @showPrevSlide exports

    @$slideshowNextLink.on 'click', (e) =>
      e.preventDefault()
      @showNextSlide exports

  showPrevSlide: (exports) ->
    if @activeSlide is 1
      newSlide = @slidesCount
    else
      newSlide = @activeSlide - 1

    @toggleSlide newSlide

  showNextSlide: (exports) ->
    if @activeSlide is @slidesCount
      newSlide = 1
    else
      newSlide = @activeSlide + 1

    @toggleSlide newSlide

  toggleSlide: (newSlide) ->
    $activeSlide = @$slideshow.find ".slide[data-slide='#{@activeSlide}']"
    $newSlide = @$slideshow.find ".slide[data-slide='#{newSlide}']"

    TweenLite.to $activeSlide, .3,
      display: 'none'
      opacity: 0

    TweenLite.to $newSlide, .3,
      display: 'block'
      opacity: 1
      delay: .3

    @activeSlide = newSlide

  resize: ->

App.FXs.push new App.Slideshow
