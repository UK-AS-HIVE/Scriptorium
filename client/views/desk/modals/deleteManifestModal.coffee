Template.deleteManifestModal.onCreated ->
  @error = new ReactiveVar
  @loading = new ReactiveVar false

Template.deleteManifestModal.helpers
  manifest: -> AvailableManifests.findOne(@manifestId)
  error: -> Template.instance().error.get()

Template.deleteManifestModal.events
  'click button[data-action=deleteManifest]': (e, tpl) ->
    if tpl.$('input[name=confirmDelete]').val() is 'Delete'
      tpl.error.set null
      tpl.loading.set true
      Meteor.call 'deleteManifest', tpl.data.manifestId, (err, res) ->
        if err
          tpl.error.set err
          tpl.loading.set false
        else
          tpl.$('#deleteManifestModal').modal('hide')

    else
      tpl.error.set "Please enter 'Delete' in the above text input to confirm deletion."

  'hidden.bs.modal': (e, tpl) ->
     Blaze.remove tpl.view

