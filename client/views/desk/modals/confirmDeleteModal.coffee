Template.deskConfirmDeleteModal.events
  'click button[data-action=delete]': (e, tpl) ->
    Meteor.call 'deleteEditorDoc', tpl.data._id
    tpl.$('#confirmDeleteModal').modal('hide')

  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

