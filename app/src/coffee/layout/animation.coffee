class App.Animation
  constructor: ->
    @order = 0

  build: (exports) ->
    exports.AnimationController = @
    exports.controllers.push @

    @scrollTop = null
    @currentProgressValue = 0
    @initiated = false
    @activeOverlay = null
    @goToSection = null

    @pannelsTL = undefined
    @deviceTL = undefined
    @homeAboutTL = undefined
    @aboutWorkTL = undefined
    @workSkillsTL = undefined
    @contactTL = undefined
    @formTL = undefined

    @init exports

  init: (exports) ->
    @$window = $(window)
    @$body = $('body')

    @$ui = $('.menu-btn, .contact-link')

    @$homeElements = $('.home-title, .home-lead, .home-copy, .scroll-cta')
    @$logo = $('.shape-logo')

    @$deviceContainer = $('.device-container')
    @$deviceWrapper = @$deviceContainer.find('.device-wrapper')
    @$device = @$deviceContainer.find('.device')
    @$deviceBorderLeft = @$deviceContainer.find('.device-border.left')
    @$deviceBorderRight = @$deviceContainer.find('.device-border.right')

    @$aboutElements = $('.about-lead, .about-copy')

    @$workBg = $('.work-bg')
    @$workElements = $('.work-title, .slideshow-image, .slideshow-description, .slideshow-nav')

    @$skillsElements = $('.skills-title, .skills-lead, .skills-list, .skills-btn')

    @$overlay = $('.overlay')
    @$overlayPanelTop = @$overlay.find '.overlay-panel.top'
    @$overlayPanelBottom = @$overlay.find '.overlay-panel.bottom'
    @$overlayClose = @$overlay.find '.overlay-close'

    @$menu = @$overlay.find '.overlay-content.menu'
    @$menuElements = @$overlay.find '.nav-item'

    @$contact = @$overlay.find '.overlay-content.contact'
    @$contactElements = @$overlay.find '.contact-title, .contact-lead, .form-group, .form-action'

    @$showOverlayLink = $('.do-show-overlay')
    @$hideOverlayLink = $('.do-hide-overlay')
    @$showSectionLink = $('.do-show-section')

    setTimeout =>
      @initApp exports
    , 200

    @$showOverlayLink.on 'click', (e) =>
      e.preventDefault()
      $link = $(e.target)
      unless $link.hasClass 'do-show-overlay'
        $link = $link.parents '.do-show-overlay'
      overlay = $link.attr 'data-overlay'
      @showOverlay exports, overlay

    @$hideOverlayLink.on 'click', (e) =>
      e.preventDefault()
      @hideOverlay exports

    @$showSectionLink.on 'click', (e) =>
      e.preventDefault()
      @$menuElements.removeClass 'active'
      $link = $(e.target)
      unless $link.hasClass 'do-show-section'
        $link = $link.parents '.do-show-section'
      @goToSection = $link.addClass('active').attr 'data-section'
      @hideOverlay exports

  setDevicePosition: (exports) ->
    @posTop = $('.logo').offset().top
    @$deviceWrapper.css 'top', @posTop

  initApp: (exports) ->
    @$window.scrollTop 0

    @setDevicePosition exports

    @initTimelines exports

    @$window.on 'scroll', =>
      @scrollHandler exports

    TweenLite.to @$body, 1,
      opacity: 1
      delay: .5
      onComplete: =>
        @initiated = true

  initOverlay: (exports, overlay = 'contact') ->
    @pannelsTL = new TimelineMax
      paused: true
    .set @$deviceContainer,
      zIndex: 30
    .to @$overlayPanelTop, .3,
      y: '0%'
    .to @$overlayPanelBottom, .3,
      y: '0%'
    , '-=.3'

    @deviceTL = new TimelineMax
      paused: true
    .to @$device, .15,
      borderWidth: "#{exports.deviceSize / 2}px #{exports.deviceBorder}px"

    @device2TL = new TimelineMax
      paused: true
    .set @$device,
      borderWidth: "#{exports.deviceSize / 2}px #{exports.deviceBorder}px"
    .to @$device, .15,
      borderWidth: "#{exports.deviceBorder}px #{exports.deviceBorder}px"

    @device3TL = new TimelineMax
      paused: true
    .set @$device,
      borderWidth: "#{exports.deviceBorder / 2}px #{exports.deviceSize / 2}px"
    .to @$device, .15,
      borderWidth: "#{exports.deviceBorder / 2}px #{exports.deviceBorder / 2}px"

    @overlayContentTL = new TimelineMax
      paused: true
    .set @$deviceContainer,
      zIndex: 10
    .set @$device,
      opacity: 0
    .set @$overlayContent,
      opacity: 1
      zIndex: 20
    .to @$overlayContent, .3,
      scale: 1
      ease: Power2.easeOut
    .staggerFromTo @$overlayElements, .3,
      opacity: 0
      y: 20
    ,
      opacity: 1
      y: 0
    , .15
    .fromTo @$overlayClose, .15,
      opacity: 0
      x: -100
    ,
      opacity: 1
      x: 0
    , '-=.1'

  showOverlay: (exports, overlay = 'contact') ->
    @activeOverlay = overlay
    @$body.addClass 'no-scroll'

    @overlayTL = @contactTL = new TimelineMax
      paused: true
    .call @onComplete, [exports]

    if overlay is 'contact'
      @$overlayContent = @$contact
      @$overlayElements = @$contactElements
    else
      @$overlayContent = @$menu
      @$overlayElements = @$menuElements

    @initOverlay exports, overlay

    if @currentProgressValue < .21
      @overlayTL
      .to [ @$deviceWrapper, @$logo ], .3,
        y: (exports.windowHeight - exports.deviceSize) / 2 - @posTop
        ease: Power2.easeOut
      .staggerTo @$homeElements, .3,
        opacity: 0
        y: 20
      , .15, '-=.4'
      .set @$overlayContent,
        scale: .33

      if overlay is 'contact'
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @deviceTL.play(0), '-=.1'
        .add @overlayContentTL.play(0)
      else
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @overlayContentTL.play(0)

    else if .21 <= @currentProgressValue < .42
      @overlayTL
      .set @$overlayContent,
        scale: .33

      if overlay is 'contact'
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @deviceTL.play(0), '-=.1'
        .add @overlayContentTL.play(0)
      else
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @device2TL.play(0)
        .add @overlayContentTL.play(0)

    else if .42 <= @currentProgressValue < .6
      @overlayTL
      .to @$deviceWrapper, .3,
        scale: 2
        rotation: 90
      .set @$overlayContent,
        scale: .65

      if overlay is 'contact'
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @overlayContentTL.play(0)
      else
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @device3TL.play(0)
        .add @overlayContentTL.play(0)

    else if .6 <= @currentProgressValue < 1.31
      @overlayTL
      .staggerTo @$aboutElements, .3,
        opacity: 0
        y: 20
      , .15
      .to @$deviceBorderLeft, .3,
        x: 0
        y: 0
      , '-=.2'
      .to @$deviceBorderRight, .3,
        x: 0
        y: 0
      , '-=.3'
      .to @$deviceWrapper, .3,
        rotation: 90
      .set @$overlayContent,
        scale: .65

      if overlay is 'contact'
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @overlayContentTL.play(0)
      else
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @device3TL.play(0)
        .add @overlayContentTL.play(0)

    else if 1.31 <= @currentProgressValue < 1.46
      @overlayTL
      .to @$deviceWrapper, .3,
        rotation: 90
      .set @$overlayContent,
        scale: .65

      if overlay is 'contact'
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @overlayContentTL.play(0)
      else
        @overlayTL
        .add @pannelsTL.play(0), '-=.2'
        .add @device3TL.play(0)
        .add @overlayContentTL.play(0)

    else if 1.46 <= @currentProgressValue < 1.65
      @overlayTL
      .set @$overlayContent,
        scale: 1
      .to @$workBg, .3,
        width: exports.overlaySize
        height: exports.overlaySize
      .set @$overlayContent,
        opacity: 1
      .set @$deviceWrapper,
        opacity: 0

      if overlay is 'contact'
        @overlayTL
        .add @pannelsTL.play(0)
        .add @overlayContentTL.play(0), '-=.2'
      else
        @overlayTL
        .add @pannelsTL.play(0)
        .add @overlayContentTL.play(0), '-=.2'

    else if 1.65 <= @currentProgressValue
      @overlayTL
      .staggerTo @$workElements, .3,
        opacity: 0
        y: 20
      , .15
      .set @$overlayContent,
        scale: 1
      .to @$workBg, .3,
        width: exports.overlaySize
        height: exports.overlaySize
      .set @$overlayContent,
        opacity: 1
      .set @$deviceWrapper,
        opacity: 0

      if overlay is 'contact'
        @overlayTL
        .add @pannelsTL.play(0)
        .add @overlayContentTL.play(0), '-=.2'
      else
        @overlayTL
        .add @pannelsTL.play(0)
        .add @overlayContentTL.play(0), '-=.2'

    @overlayTL.timeScale(.9).play()

  hideOverlay: (exports) ->
    if @activeOverlay is 'contact' and exports.formSuccess? and exports.formSuccess
      successFormTL = new TimelineMax
        paused: true
      .to @$overlayClose, .15,
        opacity: 0
        x: -100
      , '+=.1'
      .staggerTo $('.fs-title, .fs-lead'), .3,
        opacity: 0
        y: 20
      , .15
      .to $('.form-success').find('.fs-bg'), .3,
        borderWidth: "#{exports.overlaySize / 2}px #{exports.deviceBorder}px"
      .set @$overlayContent,
        opacity: 1
        backgroundColor: '#ffffff'
        zIndex: 20
        onComplete: =>
          @overlayTL.reverse(-.8)
          setTimeout ->
            exports.FormController.resetForm()
          , 1000
      successFormTL.play()
    else
      @overlayTL.reverse()

    @$body.removeClass 'no-scroll'

  onComplete: (exports) =>
    if @overlayTL.reversed() and @goToSection?
      delta = switch
        when @goToSection is 'home' then 0
        when @goToSection is 'about' then 1
        when @goToSection is 'work' then 2
        when @goToSection is 'skills' then 3

      TweenLite.to @$window, 2,
        scrollTo:
          y: exports.windowHeight * delta
          ease:Power2.easeOut
        delay: .25
      @goToSection = null

  scrollTween: (startPoint, endPoint, timeline, timelinePosition) ->
    progressValue = (1 / (endPoint - startPoint)) * (@scrollTop - startPoint)

    if 0 <= progressValue <= 1
      timeline.progress progressValue
      @currentProgressValue = progressValue + timelinePosition
    else if progressValue < 0
      timeline.progress 0
    else if progressValue > 1
      timeline.progress 1

  scrollHandler: (exports) ->
    @scrollTop = @$window.scrollTop()

    @scrollTween 0, exports.windowHeight, @homeAboutTL, 0
    @scrollTween exports.windowHeight, exports.windowHeight * 2, @aboutWorkTL, 1
    @scrollTween exports.windowHeight * 3, exports.windowHeight * 3.5, @workSkillsTL, 2

  initTimelines: (exports) ->
    # Home to About
    @homeAboutTL = new TimelineMax
      paused: true
    .fromTo [ @$logo, @$deviceWrapper ], 1,
      y: 0
    ,
      y: (exports.windowHeight - exports.deviceSize) / 2 - @posTop
      ease: Power2.easeOut
    .staggerFromTo @$homeElements, 1,
      opacity: 1
      y: 0
    ,
      opacity: 0
      y: exports.gap
    , .15, '-=1'
    .fromTo @$device, 1,
      borderWidth: "#{exports.deviceBorder}"
    ,
      borderWidth: "#{exports.deviceSize / 2}px #{exports.deviceBorder}"
    .fromTo @$deviceWrapper, 1,
      scale: 1
      rotation: 0
    ,
      scale: 2
      rotation: 45
    .fromTo @$deviceBorderLeft, 1,
      x: 0
      y: 0
    ,
      x: -exports.gap / 2
      y: exports.gap / 2
    .fromTo @$deviceBorderRight, 1,
      x: 0
      y: 0
    ,
      x: exports.gap / 2
      y: -exports.gap / 2
    , '-=1'
    .staggerFromTo @$aboutElements, 1,
      opacity: 0
      y: exports.gap
    ,
      opacity: 1
      y: 0
    , .15
    .add -> @currentSection = 'about'

    # About to Work
    @aboutWorkTL = new TimelineMax
      paused: true
    .staggerTo @$aboutElements, 1,
      opacity: 0
      y: -exports.gap
    , .15
    .to @$deviceBorderLeft, 1,
      x: 0
      y: 0
    .to @$deviceBorderRight, 1,
      x: 0
      y: 0
    , '-=1'
    .to @$deviceWrapper, 1,
      rotation: 90
    .fromTo @$workBg, 0,
      opacity: 0
    ,
      opacity: 1
    .set @$deviceContainer,
      zIndex: 0
    .to @$workBg, 1,
      width: exports.windowWidth - exports.gap * 2
      height: exports.windowHeight - exports.gap * 2
    .to @$ui, 1,
      color: exports.primaryColor
    , '-=.2'
    .staggerFromTo @$workElements, 1,
      opacity: 0
      y: exports.gap
    ,
      opacity: 1
      y: 0
    , .15, '-=1'
    .to @$workElements, 1,
      opacity: 1

    # Work to skills
    @workSkillsTL = new TimelineMax
      paused: true
    .to @$ui, 1,
      color: exports.secondaryColor
    .staggerFromTo @$skillsElements, 1,
      opacity: 0
      y: exports.gap
    ,
      opacity: 1
      y: 0
    , .3, '=+1'


  resize: (exports) ->
    if @initiated
      @setDevicePosition exports

App.FXs.push new App.Animation
