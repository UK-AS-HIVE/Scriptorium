Template.addManifestModal.events
  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

  'click button[data-action=addManifest]': (e, tpl) ->
    tpl.loading.set true
    Meteor.call "getManifest", tpl.$("#newManifestURL").val().trim(), tpl.$("#newManifestLocation").val(), tpl.$("#newManifestTitle").val(), Session.get("current_project"), (err, res) ->
      if err
        tpl.error.set err.message
        tpl.loading.set false
      else
        tpl.$("#addManifestModal").modal('hide')


Template.addManifestModal.helpers
  error: -> Template.instance().error.get()
  loading: -> Template.instance().loading.get()

Template.addManifestModal.onCreated ->
  @error = new ReactiveVar
  @loading = new ReactiveVar(false)


