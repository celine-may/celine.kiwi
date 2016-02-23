class App.Animation
  constructor: ->
    @order = 0

  build: (exports) ->
    exports.AnimationController = @
    exports.controllers.push @

    @homeToContactTL = undefined

    @init exports

  init: (exports) ->
    @$body = $('body')
    @$homeElements = $('.home-title, .home-lead, .home-copy')
    @$logo = $('.shape-logo')
    @$device = $('.device')
    @$sectionContent = $('.home .section-content')
    @$overlay = $('.overlay')
    @$overlayPanelTop = @$overlay.find '.overlay-panel.top'
    @$overlayPanelBottom = @$overlay.find '.overlay-panel.bottom'
    @$overlayContent = @$overlay.find '.overlay-content.contact'
    @$overlayClose = @$overlay.find '.overlay-close'
    @$contactElements = @$overlayContent.find '.contact-title, .contact-lead, .form-group, .form-action'

    @$showContactLink = $('.do-show-contact')
    @$hideContactLink = $('.do-hide-contact')

    @setDevicePosition exports
    @yPos = (exports.windowHeight - exports.deviceSize) / 2 - @posTop

    @initTimelines exports
    @initApp()

    @$showContactLink.on 'click', (e) =>
      e.preventDefault()
      @showContact exports

    @$hideContactLink.on 'click', (e) =>
      e.preventDefault()
      @hideContact exports

  setDevicePosition: (exports) ->
    @posTop = $('.logo').offset().top
    @$device.css 'top', @posTop

  initApp: ->
    TweenLite.to @$body, 1,
      opacity: 1
      delay: .75

  showContact: (exports) ->
    if exports.section is 'home'
      @homeToContactTL.timeScale(.8).play(0)

  hideContact: (exports) ->
    if exports.formSuccess? and exports.formSuccess and exports.section is 'home'
      contactTL2 = new TimelineMax
        paused: true
      .staggerTo $('.form-success-copy .title, .form-success-copy .lead'), .3,
        opacity: 0
      , .15
      .to $('.form-success-bg'), .3,
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

  initTimelines: (exports) ->
    @homeToContactTL = new TimelineMax
      paused: true
    .fromTo [ @$device, @$logo ], .4,
      y: 0
    ,
      y: @yPos
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
    @setDevicePosition exports

App.FXs.push new App.Animation
