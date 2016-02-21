$ ->
  # DOM Elements
  $form = $('.form')
  $formBtn = $form.find '.form-btn'
  $contactContent = $('.overlay-content.contact')
  $contactElements = $contactContent.find '.contact-title, .contact-lead, .form-group, .form-action'

  $formError = undefined
  $formSuccess = undefined

  # Variables
  send = false
  regexEmail = /^.+@.+\..+$/i
  formHeight = null

  # Functions
  addError = ($field) ->
    send = false
    if $field.hasClass 'error'
      return

    $field.addClass 'error'
    showErrorMessage()

  showErrorMessage = ->
    unless $formError?
      $formError = $('<p class="form-error">Please complete highlighted fields</p>')
      $form.append $formError

    TweenLite.fromTo $formError, .3,
      y: '100%'
    ,
      y: '0%'

  hideErrorMessage = ->
    unless $formError?
      return

    TweenLite.to $formError, .3,
      y: '100%'

  validateForm = (e) ->
    e.preventDefault()

    send = true

    $form
      .find '.error'
      .removeClass 'error'

    $form.find('[data-validation]').each ->
      $this = $(this)
      validation = $this.data('validation').split ' '

      if $.inArray('required', validation) != -1 and $this.val() is ''
        addError $this.parents('.form-group')

      if $this.val() isnt '' and $.inArray('email', validation) != -1 and !regexEmail.test $this.val()
        addError $this.parents('.form-group')

    if send
      $formBtn.addClass 'active'
      getData()

    false

  getData = ->
    data = {
      'name': $form.find('#name').val()
      'email': $form.find('#email').val()
      'message': $form.find('#message').val()
    }
    sendEmail data

  sendEmail = (data) ->
    $.post "#{App.path}helpers/mailer.php", data, (data) ->
      if data is 'success'
        showSuccessMessage()
      else
        console.log 'error'

  showSuccessMessage = ->
    $formSuccess = $("""
<div class="form-success">
  <div class="form-success-bg"></div>
  <div class="form-success-copy">
    <p class="title">Thanks for your message.</p>
    <p class="lead">I'll be in touch shortly.</p>
  </div>
</div>""")
    $contactContent.append $formSuccess

    successTL = new TimelineMax()
    .staggerTo $contactElements, .3,
      opacity: 0
    , .2
    .set $contactContent,
      backgroundColor: 'transparent'
    .set $formSuccess,
      opacity: 1
    .to $formSuccess.find('.form-success-bg'), .3,
      borderWidth: "#{App.deviceBorder}px"
    .fromTo $formSuccess.find('.form-success-copy'), .3,
      opacity: 0
    ,
      opacity: 1
      ease: Power2.easeOut

  # Events
  $form.on 'submit', validateForm
  $form.on 'keydown', hideErrorMessage
