class App.Form
  constructor: ->
    @order = 1

  build: (exports) ->
    exports.FormController = @
    exports.controllers.push @

    @init exports

  init: (exports) ->
    # DOM Elements
    @$form = $('.form')
    @$formBtn = @$form.find '.form-btn'
    @$contactContent = $('.overlay-content.contact')
    @$contactElements = @$contactContent.find '.contact-title, .contact-lead, .form-group, .form-action'

    @$formError = undefined
    @$formSuccess = undefined

    # Variables
    @send = false
    @exports = exports

    # Events
    @$form.on 'submit', (e) =>
      e.preventDefault()
      @validateForm()

    @$form.on 'keydown', @hideErrorMessage

  addError: ($field) ->
    @send = false
    if $field.hasClass 'error'
      return

    $field.addClass 'error'
    @showErrorMessage()

  showErrorMessage: ->
    unless @$formError?
      @$formError = $('<p class="form-error">Please complete highlighted fields</p>')
      @$form.append @$formError

    TweenLite.fromTo @$formError, .3,
      y: '100%'
    ,
      y: '0%'

  hideErrorMessage: =>
    unless @$formError?
      return

    TweenLite.to @$formError, .3,
      y: '100%'

  validateForm: ->
    @send = true

    @$form
      .find '.error'
      .removeClass 'error'

    for field in @$form.find('[data-validation]')
      $field = $(field)
      validation = $field.data('validation').split ' '

      if $.inArray('required', validation) != -1 and $field.val() is ''
        @addError $field.parents('.form-group')

    if @send
      @getData()

    false

  getData: ->
    data = {
      'name': @$form.find('#name').val()
      'email': @$form.find('#email').val()
      'message': @$form.find('#message').val()
    }
    @sendEmail data

  sendEmail: (data) ->
    $.post "#{@exports.path}helpers/mailer.php", data, (data) =>
      if data is 'success'
        @showSuccessMessage()
      else
        console.log 'error'

  showSuccessMessage: ->
    @exports.formSuccess = true
    @$formSuccess = $("""
<div class="form-success">
  <div class="form-success-bg"></div>
  <div class="form-success-copy">
    <p class="title">Thanks for your message.</p>
    <p class="lead">I'll be in touch shortly.</p>
  </div>
</div>""")
    @$contactContent.append @$formSuccess

    successTL = new TimelineMax
      paused: true
    .staggerTo @$contactElements, .3,
      opacity: 0
    , .15
    .set @$contactContent,
      backgroundColor: 'transparent'
    .set @$formSuccess,
      opacity: 1
    .to @$formSuccess.find('.form-success-bg'), .3,
      borderWidth: "#{@exports.deviceBorder}px"
    .fromTo @$formSuccess.find('.form-success-copy'), .3,
      opacity: 0
    ,
      opacity: 1
      ease: Power2.easeOut

    successTL.timeScale(.8).play()

  resetForm: ->
    TweenLite.set @$contactElements,
      opacity: 1
    TweenLite.set @$contactContent,
      backgroundColor: '#ffffff'
    @$formSuccess.remove()

  resize: ->

App.FXs.push new App.Form
