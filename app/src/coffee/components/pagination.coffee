class App.Pagination
  constructor: ->
    @order = 11

  build: (exports) ->
    exports.PaginationController = @
    exports.controllers.push @

    @init exports

  init: (exports) ->
    # DOM Elements
    @$skills = $('.skills-list')
    @$items = @$skills.find '.skill'
    @$nav = $('.skills-nav')

    # Variables
    if exports.isSmall
      @itemsPerPage = 8
    else
      @itemsPerPage = 12
    @itemsCount = @$items.length
    @pagesCount = Math.ceil(@itemsCount / @itemsPerPage)
    @activePage = 1

    # Events
    @initItems exports
    @createNav exports
    @toggleNavActive exports

  initItems: (exports) ->
    for item, index in @$items
      if index is @itemsPerPage
        return
      $(item).addClass 'init active'

  createNav: (exports) ->
    for i in [ 1..@pagesCount ]
      $navItem = $("""
  <button class="sn-item" data-page="#{i}">
    <span></span>
  </button>
      """)
      @$nav.append $navItem

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

    delta = 1
    if page > @activePage
      delta = -1

    TweenLite.fromTo $itemsToHide, .4,
      display: 'inline-block'
      opacity: 1
      x: 0
    ,
      display: 'none'
      opacity: 0
      x: 100 * delta
      className: '-=active'
    TweenLite.fromTo $itemsToShow, .4,
      display: 'none'
      opacity: 0
      x: -100 * delta
    ,
      display: 'inline-block'
      opacity: 1
      x: 0
      className: '+=active'
      delay: .4

    @activePage = page
    @toggleNavActive exports

  toggleNavActive: (exports) ->
    @$nav
      .find '.active'
      .removeClass 'active'

    @$nav
      .find ".sn-item[data-page='#{@activePage}']"
      .addClass 'active'

  onResize: (exports) ->
    if exports.isSmall
      @itemsPerPage = 8
    else
      @itemsPerPage = 12

  onScroll: (exports, scrollY) ->

App.FXs.push new App.Pagination
