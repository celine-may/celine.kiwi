class App.Slideshow
  constructor: ->
    @order = 10

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

    @toggleSlide exports, newSlide, 1

  showNextSlide: (exports) ->
    if @activeSlide is @slidesCount
      newSlide = 1
    else
      newSlide = @activeSlide + 1

    @toggleSlide exports, newSlide, -1

  toggleSlide: (exports, newSlide, direction) ->
    $activeSlide = @$slideshow.find ".slide[data-slide='#{@activeSlide}']"
    $activeSlideElements = $activeSlide.find '.slide-image, .slide-description'
    $newSlide = @$slideshow.find ".slide[data-slide='#{newSlide}']"
    $newSlideElements = $newSlide.find '.slide-image, .slide-description'

    if direction is 1
      $activeSlideElements = $activeSlideElements.toArray().reverse()
      $newSlideElements = $newSlideElements.toArray().reverse()

    unless exports.isMedium or exports.isSmall
      slideTL = new TimelineMax()
      .staggerFromTo $activeSlideElements, .3,
        opacity: 1
        x: 0
      ,
        opacity: 0
        x: 100 * direction
        ease: Power2.easeOut
      , .15
      .set $activeSlide,
        opacity: 0
        pointerEvents: 'none'
      .set $newSlide,
        opacity: 1
        pointerEvents: 'auto'
      .staggerFromTo $newSlideElements, .3,
        opacity: 0
        x: 100 * direction * -1
      ,
        opacity: 1
        x: 0
        ease: Power2.easeOut
      , .15
    else
      slideTL = new TimelineMax()
      .to $activeSlide, .3,
        display: 'none'
        opacity: 0
        pointerEvents: 'none'
        x: 100 * direction
        ease: Power2.easeOut
      .fromTo $newSlide, .3,
        x: 100 * direction * -1
      ,
        display: 'block'
        opacity: 1
        x: 0
        ease: Power2.easeOut

    @activeSlide = newSlide

  onResize: (exports) ->

  onScroll: (exports, scrollY) ->

App.FXs.push new App.Slideshow
