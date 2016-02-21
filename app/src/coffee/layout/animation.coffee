class App.Animation
  constructor: ->
    @order = 0

  build: (exports) ->
    exports.AnimationController = @
    exports.controllers.push @

    @contactTL = undefined

    @init exports

  init: (exports) ->
    @$homeElements = $('.home-title, .home-lead, .home-copy')
    @$logo = $('.shape-logo')
    @$device = $('.device')
    @$sectionContent = $('.home .section-content')
    @$overlay = $('.overlay')
    @$overlayPanels = @$overlay.find '.overlay-panel'
    @$overlayContent = @$overlay.find '.overlay-content.contact'
    @$overlayClose = @$overlay.find '.overlay-close'
    @$contactElements = @$overlayContent.find '.contact-title, .contact-lead, .form-group, .form-action'

    @$showContactLink = $('.do-show-contact')
    @$hideContactLink = $('.do-hide-contact')

    @setDevicePosition exports
    yPos = (exports.windowHeight - exports.deviceSize) / 2 - @posTop

    @contactTL = new TimelineMax
      paused: true
    .staggerTo @$homeElements, .3,
      opacity: 0
      y: 20
    , .15
    .to [ @$device, @$logo ], .4,
      y: yPos
      ease: Power2.easeOut
    , '-=.6'
    .to @$overlayPanels, .3,
      y: 0
    .to @$device, .15,
      borderWidth: "#{exports.deviceSize / 2}px #{exports.deviceBorder}"
    , '-=.1'
    .set @$overlayContent,
      opacity: 1
    , '+=.2'
    .set @$device,
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

    @$showContactLink.on 'click', (e) =>
      e.preventDefault()
      @showContact()
    @$hideContactLink.on 'click', (e) =>
      e.preventDefault()
      @hideContact()

  setDevicePosition: (exports) ->
    @posTop = @$sectionContent.offset().top
    @$device.css 'top', @posTop

  showContact: ->
    @contactTL.timeScale(.6).play()

  hideContact: ->
    @contactTL.reverse()

  resize: (exports) ->
    @setDevicePosition exports

App.FXs.push new App.Animation
