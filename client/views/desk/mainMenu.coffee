Template.mirador_mainMenu.onRendered ->
  # Window Options
  windowOptions = $('<div/>')
  Blaze.render(Template.mirador_mainMenu_windowOptionsMenu, windowOptions.get(0))
  @.$('.window-options').tooltipster
    arrow: true
    content: windowOptions
    contentCloning: false
    interactive: true
    theme: '.tooltipster-mirador'

  # menu 'Clear Local Storage'
  clearLocalStorage = $('<div/>')
  Blaze.render(Template.mirador_mainMenu_clearLocalStorage, clearLocalStorage.get(0))
  @.$('.clear-local-storage').tooltipster
    arrow: true
    content: clearLocalStorage
    contentCloning: false
    interactive: true
    theme: '.tooltipster-mirador'


Template.mirador_mainMenu_menuItems.events
  'click a[data-action=toggle-panel]': (e, tpl) ->
    panelId = tpl.$(e.target).data('panel')
    if panelId is '#desk-chat-panel'
      tpl.chatBadgeCount.set 0
    $('.desk-panel').not(panelId).removeClass('is-open')
    $(panelId).toggleClass('is-open')

Template.mirador_mainMenu_menuItems.helpers
  count: -> Template.instance().chatBadgeCount.get()

Template.mirador_mainMenu_menuItems.onCreated ->
  @chatBadgeCount = new ReactiveVar(0)
  loadedTime = new Date()
  tpl = @
  EventStream.find( {timestamp: { $gt: loadedTime } }).observe
    added: (doc) ->
      unless doc.userId is Meteor.userId() or $('#desk-chat-panel').hasClass('is-open')
        tpl.chatBadgeCount.set tpl.chatBadgeCount.get()+1


Template.mirador_mainMenu_windowOptionsMenu.events
  'click .window-options-menu .cascade-all': ->
    widgets = DeskWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      DeskWidgets.update aw._id,
        $set:
          x: 5 + 25*i
          y: 5 + 25*i

  'click .window-options-menu .tile-all-vertically': ->
    deskHeight = $('.mirador-viewer').height() - 45
    deskWidth = $('.mirador-viewer').width() - 5
    widgets = DeskWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      DeskWidgets.update aw._id,
        $set:
          x: 5
          y: 5+i*(deskHeight/widgetCount)
          width: deskWidth - 10
          height: deskHeight/widgetCount - 5

  'click .window-options-menu .tile-all-horizontally': ->
    deskHeight = $('.mirador-viewer').height() - 45
    deskWidth = $('.mirador-viewer').width() - 5
    widgets = DeskWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      DeskWidgets.update aw._id,
        $set:
          x: 5+i*(deskWidth/widgetCount)
          y: 5
          width: deskWidth/widgetCount - 5
          height: deskHeight - 10

  'click .window-options-menu .stack-all-vertically-2-cols': ->
    deskHeight = $('.mirador-viewer').height() - 45
    deskWidth = $('.mirador-viewer').width() - 5
    widgets = DeskWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      DeskWidgets.update aw._id,
        $set:
          x: 5+(i%2)*(deskWidth/2)
          y: 5+Math.floor(i/2)*(deskHeight/Math.ceil(widgetCount/2))
          width: deskWidth/2 - 5
          height: deskHeight/Math.ceil(widgetCount/2) - 5

  'click .window-options-menu .stack-all-vertically-3-cols': ->
    deskHeight = $('.mirador-viewer').height() - 45
    deskWidth = $('.mirador-viewer').width() - 5
    widgets = DeskWidgets.find()
    widgetCount = widgets.count()
    _.each widgets.fetch(), (aw, i) ->
      DeskWidgets.update aw._id,
        $set:
          x: 5+(i%3)*(deskWidth/3)
          y: 5+Math.floor(i/3)*(deskHeight/Math.ceil(widgetCount/3))
          width: deskWidth/3 - 5
          height: deskHeight/Math.ceil(widgetCount/3) - 5

  'click .window-options-menu .close-all': ->
    DeskWidgets.find().forEach (aw) ->
      DeskWidgets.remove aw._id

Template.mirador_mainMenu_clearLocalStorage.events
  'click button[data-action=cancel]': ->
    $('.clear-local-storage').tooltipster('hide')

  'click button[data-action=clear]': (e, tpl) ->
    DeskWidgets.find().forEach (aw) ->
      DeskWidgets.remove aw._id
    $('.clear-local-storage').tooltipster('hide')
