class App.Animation
  constructor: ->
    @order = 0

  build: (exports) ->
    exports.AnimationController = @
    exports.controllers.push @

    @canPlayVideo = undefined
    @currentProgressValue = 0
    @initiated = false
    @activeSection = undefined
    @zHidden = -1
    @zBase = 10
    @zTop = 20

    @toggleSectionEvent = document.createEvent 'Event'
    @toggleSectionEvent.initEvent 'toggleSection', true, true

    @init exports

  init: (exports) ->
    # DOM Elements
    @$window = $(window)
    @$body = $('body')
    @$video = $('.video-bg')
    @$ui = $('.menu-btn, .contact-link')
    @$nav = $('.nav')

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
    @$showSectionLink = $('.do-show-section')
    @$showAboutLink = $('.do-show-about')

    # Events
    setTimeout =>
      @initApp exports
    , 1000

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
      @newSection = $link.addClass('active').attr 'data-section'
      @hideOverlay exports

    @$showAboutLink.on 'click', (e) =>
      e.preventDefault()
      @newSection = 'about'
      @goToSection exports,

    @$window.on 'toggleSection', (e) =>
      @toggleSection()

    @$video[0].addEventListener 'canplay', @canPlay, true

  setDevicePosition: (exports) ->
    @posTop = $('.logo').offset().top
    @$deviceWrapper.css 'top', @posTop

  initApp: (exports) ->
    @$window.scrollTop 0
    @scrollTop = 0
    @setActiveSection exports

    @setDevicePosition exports
    unless exports.isTouch or exports.isSmall
      @initTimelines exports
    @initSection exports
    @playVideo exports

    @$window.on 'scroll', =>
      @scrollHandler exports

    TweenLite.to @$body, 1,
      opacity: 1
      delay: .5
      ease: Power2.easeOut
      onComplete: =>
        @initiated = true
        @playVideo exports

  canPlay: =>
    @canPlayVideo = true

  playVideo: (exports) ->
    if @canPlayVideo and @initiated
      @$video[0].play()
    unless @canPlayVideo
      @$video.remove()
      $('.video-bg-fallback').css
        height: exports.windowHeight + 75
        opacity: 1

  initSection: (exports) ->
    $(".section.#{@activeSection} .section-content").css 'z-index', @zTop

  initOverlay: (exports, overlay = 'contact') ->
    @$overlay.css 'z-index', 30

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
    .call @onOverlayTLComplete, [exports]

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

    else if 1.65 <= @currentProgressValue < 2.4
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

    else if 2.4 <= @currentProgressValue
      @overlayTL
      .set @$overlayContent,
        scale: 0

      if overlay is 'contact'
        @overlayTL
        .add @pannelsTL.play(0)
        .add @overlayContentTL.play(0), '-=.1'
      else
        @overlayTL
        .add @pannelsTL.play(0)
        .add @overlayContentTL.play(0), '-=.1'

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

  onOverlayTLComplete: (exports) =>
    if @overlayTL.reversed()
      @$overlay.css 'z-index', -1
    if @overlayTL.reversed() and @newSection?
      @goToSection exports

  goToSection: (exports) ->
    delta = switch
      when @newSection is 'home' then 0
      when @newSection is 'about' then 1
      when @newSection is 'work' then 2
      when @newSection is 'skills' then 3.5

    TweenLite.to @$window, 2,
      scrollTo:
        y: exports.windowHeight * delta
        ease:Power2.easeOut
      delay: .25
    @newSection = null

  toggleSection: ->
    @$nav
      .find '.active'
      .removeClass 'active'

    @$nav
      .find ".nav-item[data-section='#{@activeSection}']"
      .addClass 'active'

  initTimelines: (exports) ->
    @initHomeAbout exports
    @initAboutWork exports
    @initWorkSkills exports

  # Home to About TL
  initHomeAbout: (exports) ->
    @homeAboutTL = new TimelineMax
      paused: true
    .set @$home,
      zIndex: @zBase
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
    .to @$workElements, 1,
      opacity: 1

  # Work to skills TL
  initWorkSkills: (exports) ->
    @workSkillsTL = new TimelineMax
      paused: true
    .staggerTo @$workElements, 1,
      opacity: 0
      y: -exports.gap
    , .15
    .set @$skills,
      zIndex: @zBase - 1
    .fromTo @$skills, 1,
      opacity: 0
    ,
      opacity: 1
    .to @$workBg, 1,
      marginTop: '-100%'
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
    , .3

  setActiveSection: (exports) ->
    if @scrollTop < exports.windowHeight / 2
      newSection = 'home'
    else if exports.windowHeight / 2 <= @scrollTop < exports.windowHeight * 1.5
      newSection = 'about'
    else if exports.windowHeight * 1.5 <= @scrollTop < exports.windowHeight * 3
      newSection = 'work'
    else
      newSection = 'skills'

    if newSection isnt @activeSection
      @activeSection = newSection
      window.dispatchEvent @toggleSectionEvent

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
    @setActiveSection exports

    unless exports.isTouch or exports.isSmall
      @scrollTween 0, exports.windowHeight, @homeAboutTL, 0
      @scrollTween exports.windowHeight * 1.2, exports.windowHeight * 2.2, @aboutWorkTL, 1
      @scrollTween exports.windowHeight * 2.4, exports.windowHeight * 3.4, @workSkillsTL, 2

  resize: (exports) ->
    if @initiated
      @setDevicePosition exports

App.FXs.push new App.Animation
