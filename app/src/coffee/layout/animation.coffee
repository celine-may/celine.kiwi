class App.Animation
  constructor: ->
    @order = 0

  build: (exports) ->
    exports.AnimationController = @
    exports.controllers.push @

    @scrollTop = null
    @initiated = false

    @homeAboutTL = undefined
    @homeToContactTL = undefined

    @init exports

  init: (exports) ->
    @$window = $(window)
    @$body = $('body')

    @$homeElements = $('.home-title, .home-lead, .home-copy, .scroll-cta')
    @$logo = $('.shape-logo')

    @$deviceWrapper = $('.device-wrapper')
    @$device = @$deviceWrapper.find('.device')
    @$deviceBorderLeft = @$deviceWrapper.find('.device-border.left')
    @$deviceBorderRight = @$deviceWrapper.find('.device-border.right')

    @$aboutElements = $('.about-lead, .about-copy')

    @$overlay = $('.overlay')
    @$overlayPanelTop = @$overlay.find '.overlay-panel.top'
    @$overlayPanelBottom = @$overlay.find '.overlay-panel.bottom'
    @$overlayContent = @$overlay.find '.overlay-content.contact'
    @$overlayClose = @$overlay.find '.overlay-close'

    @$contactElements = @$overlayContent.find '.contact-title, .contact-lead, .form-group, .form-action'

    @$showContactLink = $('.do-show-contact')
    @$hideContactLink = $('.do-hide-contact')

    setTimeout =>
      @initApp exports
    , 200

    @$showContactLink.on 'click', (e) =>
      e.preventDefault()
      @showContact exports

    @$hideContactLink.on 'click', (e) =>
      e.preventDefault()
      @hideContact exports

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

  showContact: (exports) ->
    if exports.section is 'home'
      @homeToContactTL.timeScale(.8).play(0)

  hideContact: (exports) ->
    if exports.formSuccess? and exports.formSuccess and exports.section is 'home'
      contactTL2 = new TimelineMax
        paused: true
      .staggerTo $('.fs-title, .fs-lead'), .3,
        opacity: 0
      , .15
      .to $('.fs-bg'), .3,
        borderWidth: "#{exports.overlaySize / 2}px #{exports.deviceBorder}px"
      .to @$overlayClose, .15,
        opacity: 0
        x: -100
      .to @$overlayContent, .3,
        scale: .32667
        ease: Power2.easeOut
      .set @$overlayContent,
        opacity: 0
      .set @$device,
        opacity: 1
      .to @$overlayPanelTop, .3,
        y: '-100%'
      .to @$overlayPanelBottom, .3,
        y: '100%'
      , '-=.3'
      .to @$device, .15,
        borderWidth: "#{exports.deviceBorder}px"
      , '-=.3'
      .to [ @$device, @$logo ], .4,
        y: 0
        onComplete: ->
          exports.FormController.resetForm()
        ease: Power2.easeOut
      .staggerTo @$homeElements, .3,
        opacity: 1
        y: 0
      , .15, '-=.4'

      contactTL2.timeScale(.8).play()
    else if exports.section is 'home'
      @homeToContactTL.reverse()

  scrollTween: (startPoint, endPoint, tweenName) ->
    progressNumber = (1 / (endPoint - startPoint)) * (@scrollTop - startPoint)

    if 0 <= progressNumber <= 1
      tweenName.progress progressNumber
    else if progressNumber < 0
      tweenName.progress 0
    else if progressNumber > 1
      tweenName.progress 1

  scrollHandler: (exports) ->
    @scrollTop = @$window.scrollTop()

    @scrollTween 0, exports.windowHeight, @homeAboutTL

  initTimelines: (exports) ->
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

    @homeToContactTL = new TimelineMax
      paused: true
    .fromTo [ @$deviceWrapper, @$logo ], .4,
      y: 0
    ,
      y: (exports.windowHeight - exports.deviceSize) / 2 - @posTop
      ease: Power2.easeOut
    .staggerFromTo @$homeElements, .3,
      opacity: 1
      y: 0
    ,
      opacity: 0
      y: 20
    , .15, '-=.4'
    .fromTo @$overlayPanelTop, .3,
      y: '-100%'
    ,
      y: '0%'
    .fromTo @$overlayPanelBottom, .3,
      y: '100%'
    ,
      y: '0%'
    , '-=.3'
    .fromTo @$device, .15,
      borderWidth: "#{exports.deviceBorder}"
    ,
      borderWidth: "#{exports.deviceSize / 2}px #{exports.deviceBorder}"
    , '-=.1'
    .fromTo @$overlayContent, 0,
      opacity: 0
    ,
      opacity: 1
    , '+=.2'
    .fromTo @$device, 0,
      opacity: 1
    ,
      opacity: 0
    .fromTo @$overlayContent, .3,
      scale: .32667
    ,
      scale: 1
      ease: Power2.easeOut
    , '+=.2'
    .staggerFromTo @$contactElements, .3,
      opacity: 0
      y: 20
    ,
      opacity: 1
      y: 0
    , .15
    .fromTo @$overlayClose, .15,
      x: -100
    ,
      x: 0
    , '-=.1'

  resize: (exports) ->
    if @initiated
      @setDevicePosition exports

App.FXs.push new App.Animation
