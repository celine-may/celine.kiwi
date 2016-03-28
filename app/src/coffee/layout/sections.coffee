class App.Sections
  constructor: ->
    @order = 0

  build: (exports) ->
    exports.SectionsController = @
    exports.controllers.push @

    @canPlayVideo = undefined
    @initiated = false
    @activeSection = exports.activeSection

    @sectionSwitchEvent = document.createEvent 'Event'
    @sectionSwitchEvent.initEvent 'sectionSwitch', true, true

    @init exports

  init: (exports) ->
    # DOM Elements
    @$window = $(window)
    @$body = $('body')
    @$video = $('.video-bg')
    @$ui = $('.menu-btn, .contact-link')
    @$nav = $('.nav')
    @$menuElements = @$nav.find '.nav-item'

    @$home = $('.home')
    @$about = $('.about')
    @$work = $('.work')
    @$skills = $('.skills')

    @$showSectionLink = $('.do-show-section')
    @$showAboutLink = $('.do-show-about')

    # Variables
    if exports.isSmall
      @aboutGap = -70
    else if not exports.isSmall and exports.isTouch
      @aboutGap = -20
    else
      @aboutGap = 0

    if exports.isTouch
      @delta = 1
    else
      @delta = 1.4

    # Events
    @initVideo exports

    setTimeout =>
      @initApp exports
    , 500

    @$showSectionLink.on 'click', (e) =>
      e.preventDefault()
      @$menuElements.removeClass 'active'
      $link = $(e.target)
      unless $link.hasClass 'do-show-section'
        $link = $link.parents '.do-show-section'
      newSection = exports.newSection = $link.addClass('active').attr 'data-section'
      @goToSection exports, newSection, 0, 0

    @$showAboutLink.on 'click', (e) =>
      e.preventDefault()
      @goToAbout exports

    @$window.on 'sectionSwitch', (e) =>
      @toggleSection exports

  initVideo: (exports) ->
    Modernizr.on 'videoautoplay', (autoplay) =>
      if autoplay
        @canPlayVideo = true
      else
        @canPlayVideo = false
        $('.video-fallback').css
          height: exports.windowHeight + 75
          opacity: 1
        @$video.remove()

  initApp: (exports) ->
    @$window.scrollTop 0

    exports.AnimationController.setDevicePosition exports
    unless exports.isTouch or exports.isSmall
      exports.AnimationController.initTimelines exports

    @getSectionHeights exports

    TweenLite.to @$body, 1,
      opacity: 1
      delay: .5
      ease: Power2.easeOut
      onComplete: =>
        @initiated = exports.initiated = true

  getSectionHeights: (exports) ->
    @homeHeight = $('.home').outerHeight()
    @aboutHeight = $('.about').outerHeight()
    @workHeight = $('.work').outerHeight()

  goToSection: (exports, newSection) ->
    scrollTo = switch newSection
      when 'home' then 0
      when 'about' then @$about.offset().top
      when 'work' then @$work.offset().top
      when 'skills' then @homeHeight + @aboutHeight * @delta + @workHeight * @delta

    exports.prevSection = exports.activeSection

    TweenLite.set @$window,
      scrollTo:
        y: scrollTo
        ease:Power2.easeOut
      onComplete: ->
        exports.prevProgressValue = exports.currentProgressValue || 0
        exports.AnimationController.hideOverlay exports, newSection

  goToAbout: (exports) ->
    TweenLite.to @$window, 1,
      scrollTo:
        y: @$about.offset().top + aboutGap
        ease:Power2.easeOut

  toggleSection: (exports) ->
    @$nav
      .find '.active'
      .removeClass 'active'

    @$nav
      .find ".nav-item[data-section='#{@activeSection}']"
      .addClass 'active'

    exports.activeSection = @activeSection

  setActiveSection: (exports) ->
    if @scrollTop < @homeHeight / 2
      newSection = 'home'
    else if @homeHeight / 2 <= @scrollTop < @homeHeight + @aboutHeight / 2
      newSection = 'about'
    else if @homeHeight + @aboutHeight / 2 <= @scrollTop < @homeHeight + @aboutHeight + @workHeight / 2
      newSection = 'work'
    else
      newSection = 'skills'

    if newSection isnt @activeSection
      @activeSection = newSection
      window.dispatchEvent @sectionSwitchEvent

  setUIStateMedium: (exports) ->
    if @homeHeight + @aboutHeight * .5 <= @scrollTop < @homeHeight + @aboutHeight + @workHeight * .5
      uiColor = exports.primaryColor
    else if @scrollTop >= @homeHeight + @aboutHeight + @workHeight * .5
      uiColor = exports.secondaryColor
    else
      uiColor = '#ffffff'

    @$ui.css 'color', uiColor

  setUIStateSmall: (exports) ->
    if @homeHeight + 30 <= @scrollTop < @homeHeight + @aboutHeight + @workHeight - 30
      uiColor = exports.primaryColor
    else if @scrollTop >= @homeHeight + @aboutHeight + @workHeight - 30
      uiColor = exports.secondaryColor
    else
      uiColor = '#ffffff'

    @$ui.css 'color', uiColor

  onResize: (exports) ->

  onScroll: (exports, scrollY) ->
    @scrollTop = scrollY

    @setActiveSection exports

    if exports.isSmall
      @setUIStateSmall exports
    else if not exports.isSmall and exports.isTouch
      @setUIStateMedium exports

App.FXs.push new App.Sections
