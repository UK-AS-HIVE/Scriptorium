Template.addManifestModal.events
  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

  'click button[data-action=addManifest]': (e, tpl) ->
    Meteor.call "getManifest", tpl.$("#newManifestURL").val(), tpl.$("#newManifestLocation").val(), tpl.$("#newManifestTitle").val(), Session.get("current_project"), (err, res) ->
      if err
        tpl.error.set err.message
      else
        tpl.$("#addManifestModal").modal('hide')


Template.addManifestModal.helpers
  error: -> Template.instance().error.get()

Template.addManifestModal.onCreated ->
  @error = new ReactiveVar


