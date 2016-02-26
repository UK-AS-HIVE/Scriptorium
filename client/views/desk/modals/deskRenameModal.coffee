Template.deskRenameModal.events
  'show.bs.modal': (e, tpl) ->
    tpl.$('input[name=name]').focus()
  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view

  'click button[data-action=save]': (e, tpl) ->
    FileCabinet.update tpl.data._id, { $set: { title: tpl.$('input[name=title]').val(), description: tpl.$('textarea[name=desc]').val() } }
    tpl.$('#deskRenameModal').modal('hide')

