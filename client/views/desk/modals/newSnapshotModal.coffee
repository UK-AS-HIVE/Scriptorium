Template.newSnapshotModal.events
  'click button[data-action=save]': (e, tpl) ->
    Meteor.call "saveDeskSnapshot", Session.get('current_project'), tpl.$("input[name=title]").val(), tpl.$("textarea[name=desc]").val(), (err, res) ->
      if res
        tpl.$('#new-snapshot-modal').modal('hide')

  'show.bs.modal': (e, tpl) ->
    tpl.$('input[name=name]').focus()
  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view
