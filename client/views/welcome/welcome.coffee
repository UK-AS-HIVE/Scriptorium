Template.welcome.helpers

  hasCurrentProject: ->
    if Session.get('current_project')
      return true
    else return false
