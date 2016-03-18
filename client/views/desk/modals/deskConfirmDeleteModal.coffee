Template.deskConfirmDeleteModal.events
  'click button[data-action=delete]': (e, tpl) ->
    Meteor.call 'deleteEditorDoc', tpl.data._id, (err, res) ->
      if err
        tpl.error.set err.message
      else
        tpl.$('#confirmDeleteModal').modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

Template.deskConfirmDeleteModal.helpers
  error: -> Template.instance().error.get()

Template.deskConfirmDeleteModal.onCreated ->
  @error = new ReactiveVar()
