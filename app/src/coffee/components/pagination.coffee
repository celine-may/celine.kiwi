class App.Pagination
  constructor: ->
    @order = 3

  build: (exports) ->
    exports.PaginationController = @
    exports.controllers.push @

    @init exports

  init: (exports) ->
    # DOM Elements
    @$skills = $('.skills-list')
    @$items = @$skills.find '.skill'

    # Variables
    @itemsPerPage = 12
    @itemsCount = @$items.length
    @pagesCount = Math.ceil(@itemsCount / @itemsPerPage)
    @activePage = 1

    # Events
    @initPages exports
    # @$PaginationNavLink.on 'click', (e) =>
    #   e.preventDefault()
    #   @showPage exports

  initPages: (exports) ->
    @createNav exports
    @toggleNavActive exports

    for item, index in @$items
      if index is @itemsPerPage
        return
      TweenLite.set $(item),
        display: 'inline-block'
        opacity: 1
        className: '+=active'

  createNav: (exports) ->
    @$nav = $('<div class="skills-nav"></div>')
    for i in [ 1..@pagesCount ]
      $navItem = $("""
  <button class="sn-item" data-page="#{i}">
    <span></span>
  </button>
      """)
      @$nav.append $navItem

    @$skills.after @$nav

    $('.sn-item').on 'click', (e) =>
      e.preventDefault()
      page = $(e.target).attr 'data-page'
      @switchPage exports, page

  switchPage: (exports, page) ->
    if page is @activePage
      return

    $itemsToHide = $('.skill.active')
    $itemsToShow = []
    for item, index in @$items
      if (page - 1) * @itemsPerPage <= index < page * @itemsPerPage
        $itemsToShow.push $(item)
    TweenLite.to $itemsToHide, .3,
      display: 'none'
      opacity: 0
      className: '-=active'
    TweenLite.to $itemsToShow, .3,
      display: 'inline-block'
      opacity: 1
      className: '+=active'
      delay: .3

    @activePage = page
    @toggleNavActive exports

  toggleNavActive: (exports) ->
    @$nav
      .find '.active'
      .removeClass 'active'

    @$nav
      .find ".sn-item[data-page='#{@activePage}']"
      .addClass 'active'

  resize: ->

App.FXs.push new App.Pagination
