class App.Sections
  constructor: ->
    @order = 0

  build: (exports) ->
    exports.SectionsController = @
    exports.controllers.push @

    @canPlayVideo = undefined
    @initiated = false
    @activeSection = 'home'

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

    @$showSectionLink = $('.do-show-section')
    @$showAboutLink = $('.do-show-about')

    # Events
    setTimeout =>
      @initApp exports
    , 500

    @$showSectionLink.on 'click', (e) =>
      e.preventDefault()
      @$menuElements.removeClass 'active'
      $link = $(e.target)
      unless $link.hasClass 'do-show-section'
        $link = $link.parents '.do-show-section'
      @newSection = exports.newSection = $link.addClass('active').attr 'data-section'
      exports.AnimationController.hideOverlay exports

    @$showAboutLink.on 'click', (e) =>
      e.preventDefault()
      @newSection = exports.newSection = 'about'
      @goToSection exports

    @$window.on 'sectionSwitch', (e) =>
      @toggleSection exports

    @$video[0].addEventListener 'canplay', @canPlay, true

  initApp: (exports) ->
    @$window.scrollTop 0

    exports.AnimationController.setDevicePosition exports
    unless exports.isTouch or exports.isSmall
      exports.AnimationController.initTimelines exports

    @getSectionHeights exports
    @initVideo exports

    TweenLite.to @$body, 1,
      opacity: 1
      delay: .5
      ease: Power2.easeOut
      onComplete: =>
        @initiated = exports.initiated = true
        @initVideo exports

  getSectionHeights: (exports) ->
    @homeHeight = $('.home').outerHeight()
    @aboutHeight = $('.about').outerHeight()
    @workHeight = $('.work').outerHeight()

  canPlay: =>
    @canPlayVideo = true

  initVideo: (exports) ->
    if @canPlayVideo and @initiated
      @$video[0].play()
    unless @canPlayVideo
      @$video.remove()
      $('.video-bg-fallback').css
        height: exports.windowHeight + 75
        opacity: 1

  goToSection: (exports) ->
    if exports.isMedium or exports.isSmall
      delta = 1
    else
      delta = 1.2

    scrollTo = switch
      when @newSection is 'home' then 0
      when @newSection is 'about' then @homeHeight
      when @newSection is 'work' then @homeHeight + @aboutHeight * delta
      when @newSection is 'skills' then @homeHeight + @aboutHeight * delta + @workHeight * delta

    TweenLite.to @$window, 2,
      scrollTo:
        y: scrollTo
        ease:Power2.easeOut
      delay: .25
    @newSection = exports.newSection = null

  toggleSection: (exports) ->
    @$nav
      .find '.active'
      .removeClass 'active'

    @$nav
      .find ".nav-item[data-section='#{@activeSection}']"
      .addClass 'active'

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
    if @homeHeight + @aboutHeight - 30 <= @scrollTop < @homeHeight + @aboutHeight + @workHeight - 30
      uiColor = exports.primaryColor
    else if @scrollTop >= @homeHeight + @aboutHeight + @workHeight - 30
      uiColor = exports.secondaryColor
    else
      uiColor = '#ffffff'

    @$ui.css 'color', uiColor

  onResize: (exports) ->
    if @initiated
      @setDevicePosition exports

  onScroll: (exports, scrollY) ->
    @scrollTop = scrollY

    if exports.isMedium
      @setUIStateMedium exports
    else if exports.isSmall
      @setUIStateSmall exports

App.FXs.push new App.Sections
