Template.newDocModal.events
  'click button[data-action=save]': (e, tpl) ->
    Meteor.call "newEditorDoc", Session.get('current_project'), tpl.$("input[name=title]").val(), tpl.$("textarea[name=desc]").val(), (err, res) ->
      if res
        miradorFunctions.mirador_viewer_loadView 'editorView',
          fileCabinetId: res
        tpl.$('#newDocModal').modal('hide')

  'show.bs.modal': (e, tpl) ->
    tpl.$('input[name=name]').focus()
  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view
