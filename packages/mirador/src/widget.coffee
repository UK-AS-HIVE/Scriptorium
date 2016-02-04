# TODO: Purpose of these is just wrappers to display content - need to handle resizing on them and choosing what templates to render

Template.mirador_widget_toolbar.helpers
  hidden: ->
    if !@showToolbar
      "display: none;"
  template: -> @template
  height: -> @height

Template.mirador_widget_statusbar.helpers
  hidden: ->
    if !@showToolbar
      "display: none;"
  template: -> @template
  height: -> @height
Template.mirador_widget_content.helpers
  height: ->
    # TODO: Mirador pulls the height for this element from widget - statusbar - toolbar
    @height
  template: -> @template
