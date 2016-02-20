$ ->
  # DOM Elements
  $homeElements = $('.home-title, .home-lead, .home-copy')
  $logo = $('.shape-logo')
  $device = $('.device')
  $overlay = $('.overlay')
  $overlayPanels = $overlay.find '.overlay-panel'
  $overlayContent = $overlay.find '.overlay-content.contact'
  $overlayClose = $overlay.find '.overlay-close'
  $contactElements = $overlayContent.find '.contact-title, .contact-lead, .form-group, .form-action'

  $showContactLink = $('.do-show-contact')
  $hideContactLink = $('.do-hide-contact')

  # Timeline
  yPos = (App.windowHeight - App.deviceSize) / 2 - App.posTop

  contactTL = new TimelineMax
    paused: true
  .staggerTo $homeElements, .3,
    opacity: 0
    y: 20
  , .15
  .to [ $device, $logo ], .4,
    y: yPos
    ease: Power2.easeOut
  , '-=.6'
  .to $overlayPanels, .3,
    y: 0
  .to $device, .15,
    borderWidth: "#{App.deviceSize / 2}px #{App.deviceBorder}"
  , '-=.1'
  .set $overlayContent,
    opacity: 1
  , '+=.2'
  .set $device,
    opacity: 0
  .fromTo $overlayContent, .3,
    scale: .32667
  ,
    scale: 1
    ease: Power2.easeOut
  , '+=.2'
  .staggerFromTo $contactElements, .3,
    opacity: 0
    y: 20
  ,
    opacity: 1
    y: 0
  , .15
  .fromTo $overlayClose, .15,
    x: -100
  ,
    x: 0
  , '-=.1'

  # Functions
  showContact = ->
    contactTL.timeScale(.6).play()

  hideContact = ->
    contactTL.reverse()

  # Events
  $showContactLink.on 'click', showContact
  $hideContactLink.on 'click', hideContact
