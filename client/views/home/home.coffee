Template.home.onCreated ->
  @error = new ReactiveVar
  @forgot = new ReactiveVar false
  @reset = new ReactiveVar false

Template.home.helpers
  error: -> Template.instance().error.get()
  forgot: -> Template.instance().forgot.get()
  reset: -> Template.instance().reset.get()

Template.home.events
  'click a[data-action=forgot]': (e, tpl) ->
    tpl.forgot.set true
  'click a[data-action=cancel]': (e, tpl) ->
    tpl.forgot.set false

  'submit form[name=forgot]': (e, tpl) ->
    e.preventDefault()
    Accounts.forgotPassword { email: tpl.$('input[name=email]').val() }, (err, res) ->
      if err
        tpl.error.set err.reason
      else
        tpl.error.set null
        tpl.forgot.set false
        tpl.reset.set true
        Meteor.setTimeout ->
          tpl.reset.set false
        , 5000

  'submit form[name=login]': (e, tpl) ->
    e.preventDefault()
    email = tpl.$('input[name=email]').val()
    pass = tpl.$('input[name=password]').val()
    Meteor.loginWithPassword email, pass, (err, res) ->
      if err
        tpl.error.set err.reason
      else
        tpl.error.set null
