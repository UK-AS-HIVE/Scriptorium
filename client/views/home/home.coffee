Template.home.onCreated ->
  @error = new ReactiveVar

Template.home.helpers
  error: -> Template.instance().error.get()

Template.home.events
  'submit form': (e, tpl) ->
    e.preventDefault()
    email = tpl.$('input[name=email]').val()
    pass = tpl.$('input[name=password]').val()
    Meteor.loginWithPassword email, pass, (err, res) ->
      if err
        tpl.error.set err.reason
      else
        tpl.error.set null
