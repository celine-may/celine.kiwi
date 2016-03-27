class App.Animation
  constructor: ->
    @order = 1

  build: (exports) ->
    exports.AnimationController = @
    exports.controllers.push @

    @currentProgressValue = 0
    @zHidden = -1
    @zBase = 10
    @zTop = 20
    @zXTop = 30

    @init exports

  init: (exports) ->
    # DOM Elements
    @$body = $('body')
    @$ui = $('.menu-btn, .contact-link')
    @$video = $('.video-bg.normal')
    @$videoFallback = $('.video-fallback.normal')

    # Device
    @$deviceContainer = $('.device-container')
    @$deviceWrapper = @$deviceContainer.find('.device-wrapper')
    @$device = @$deviceContainer.find('.device')
    @$deviceBorderLeft = @$deviceContainer.find('.device-border.left')
    @$deviceBorderRight = @$deviceContainer.find('.device-border.right')

    # Home
    @$home = $('.home .section-content')
    @$homeElements = @$home.find '.home-element'
    @$logo = @$home.find '.shape-logo'

    # About
    @$about = $('.about .section-content')
    @$aboutElements = @$about.find '.about-element'

    # Work
    @$work = $('.work')
    @$workBg = @$work.find '.work-bg'
    @$workElements = @$work.find '.work-element'

    # Skills
    @$skills = $('.skills')
    @$skillsElements = @$skills.find '.skills-element'

    # Overlay
    @$overlay = $('.overlay')
    @$overlayPanelTop = @$overlay.find '.overlay-panel.top'
    @$overlayPanelBottom = @$overlay.find '.overlay-panel.bottom'
    @$overlayClose = @$overlay.find '.overlay-close'

    # Menu
    @$menu = @$overlay.find '.overlay-content.menu'
    @$menuElements = @$overlay.find '.nav-item'

    # Contact
    @$contact = @$overlay.find '.overlay-content.contact'
    @$contactElements = @$overlay.find '.contact-title, .contact-lead, .form-group, .form-action'

    # Links
    @$showOverlayLink = $('.do-show-overlay')
    @$hideOverlayLink = $('.do-hide-overlay')

    # Events
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

  setDevicePosition: (exports) ->
    @posTop = $('.logo').offset().top
    @$deviceWrapper.css 'top', @posTop

  showOverlay: (exports, overlay = 'contact') ->
    @activeOverlay = overlay
    @$body.addClass 'no-scroll'

    if overlay is 'contact'
      @$overlayContent = @$contact
      @$overlayElements = @$contactElements
    else
      @$overlayContent = @$menu
      @$overlayElements = @$menuElements

    @overlayTL = @contactTL = new TimelineMax
      paused: true
    .set @$overlay,
      zIndex: @zXTop
    .to @$overlayPanelTop, .3,
      y: '0%'
    .to @$overlayPanelBottom, .3,
      y: '0%'
    , '-=.3'
    .set @$overlayContent,
      scale: .33
      opacity: 1
      zIndex: @zTop + 1
    .to @$overlayContent, .3,
      scale: 1
      ease: Power2.easeOut
    .staggerFromTo @$overlayElements, .3,
      opacity: 0
      y: 20
    ,
      opacity: 1
      y: 0
    , .1
    .fromTo @$overlayClose, .15,
      opacity: 0
      x: -100
    ,
      opacity: 1
      x: 0
    , '-=.1'
    .call @onOverlayTLComplete, [ exports ], null, '-=.5'

    @overlayTL.timeScale(.9).play()

  hideOverlay: (exports, newSection = null) ->
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
          @overlayTL.timeScale(1.5).reverse(-.8)
          setTimeout ->
            exports.FormController.resetForm()
          , 1000
      successFormTL.play()
    else
      @overlayTL.timeScale(1.3).reverse()

    @$body.removeClass 'no-scroll'

  onOverlayTLComplete: (exports) =>
    if @overlayTL.reversed()
      @showSection exports

  showSection: (exports) =>
    unless exports.prevSection?
      exports.prevSection = exports.activeSection
    if exports.prevSection is 'skills' and exports.newSection is 'home'
      @resetWork exports
      @resetAbout exports
    else if exports.prevSection is 'work' and exports.newSection is 'home'
      @resetAbout exports
    else if exports.prevSection is 'skills' and exports.newSection is 'about'
      @resetWork exports

  resetAbout: (exports) ->
    TweenLite.set @$aboutElements,
      opacity: 0
      y: exports.gap
    TweenLite.set @$deviceBorderLeft,
      x: 0
      y: 0
    TweenLite.set @$deviceBorderRight,
      x: 0
      y: 0
    TweenLite.set @$deviceWrapper,
      rotation: 0

  resetWork: (exports) ->
    TweenLite.set @$workElements,
      opacity: 0
      y: exports.gap
    @$work.css
      zIndex: 'auto'
    @$workBg.css
      zIndex: 'auto'
    @$ui.css
      color: '#ffffff'
    @$deviceContainer.css
      zIndex: @zBase

  initTimelines: (exports) ->
    @initHomeAbout exports
    @initAboutWork exports
    @initWorkSkills exports

  # Home to About TL
  initHomeAbout: (exports) ->
    @homeAboutTL = new TimelineMax
      paused: true
    .fromTo [ @$logo, @$deviceWrapper ], 1, # logo goes to center position
      y: 0
    ,
      y: (exports.windowHeight - exports.deviceSize) / 2 - @posTop
      ease: Power2.easeOut
    .staggerFromTo @$homeElements, 1, # home elements become transparent and go down
      opacity: 1
      y: 0
    ,
      opacity: 0
      y: exports.gap
    , .15, '-=1'
    .fromTo @$device, 1, # device border fills device (from top & bottom)
      borderWidth: "#{exports.deviceBorder}"
    ,
      borderWidth: "#{exports.deviceSize / 2}px #{exports.deviceBorder}"
    .fromTo @$deviceWrapper, 1, # device scales up and rotates
      scale: 1
      rotation: 0
    ,
      scale: 2
      rotation: 45
    .fromTo @$deviceBorderLeft, 1, # device external border goes to the left
      x: 0
      y: 0
    ,
      x: -exports.gap / 2
      y: exports.gap / 2
    .fromTo @$deviceBorderRight, 1, # device external border goes to the right
      x: 0
      y: 0
    ,
      x: exports.gap / 2
      y: -exports.gap / 2
    , '-=1'
    .set @$home, # set home to z-index hidden
      zIndex: @zHidden
    .set @$about, # set about to z-index top
      zIndex: @zTop
    .staggerFromTo @$aboutElements, 1, # about elements become visible and go up
      opacity: 0
      y: exports.gap
    ,
      opacity: 1
      y: 0
    , .15

  # About to Work TL
  initAboutWork: (exports) ->
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
    .set [ @$deviceContainer, @$about ],
      zIndex: @zHidden
    .set @$work,
      zIndex: @zBase
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

  # Work to skills TL
  initWorkSkills: (exports) ->
    @workSkillsTL = new TimelineMax
      paused: true
    .staggerTo @$workElements, 1,
      opacity: 0
      y: -exports.gap
    , .15
    .set @$skills,
      zIndex: @zBase
    .to @$workBg, 1,
      marginTop: '-100%'
    .to [ @$video, @$videoFallback ], 1,
      opacity: 0
    , '-=1'
    .to @$ui, 1,
      color: exports.secondaryColor
    .set [ @$work, @$workBg ],
      zIndex: @zHidden
    .staggerFromTo @$skillsElements, 1,
      opacity: 0
      y: exports.gap
    ,
      opacity: 1
      y: 0
    , .3, '-=1'

  onResize: (exports) ->
    if exports.initiated
      @setDevicePosition exports

    if @currentProgressValue > 1.6
      @$workBg.css
        width: exports.windowWidth - exports.gap * 2
        height: exports.windowHeight - exports.gap * 2

  onScroll: (exports, scrollY) ->
    @scrollTop = scrollY

    unless exports.isTouch or exports.isSmall
      exports.RendererController.scrollTween exports, 0, exports.windowHeight * 1, @homeAboutTL, scrollY, 0
      exports.RendererController.scrollTween exports, exports.windowHeight * 1.4, exports.windowHeight * 2.4, @aboutWorkTL, scrollY, 1
      exports.RendererController.scrollTween exports, exports.windowHeight * 2.8, exports.windowHeight * 3.8, @workSkillsTL, scrollY, 2

      @currentProgressValue = exports.currentProgressValue

App.FXs.push new App.Animation
