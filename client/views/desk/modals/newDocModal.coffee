Template.newDocModal.events
  'click button[data-action=save]': (e, tpl) ->
    Meteor.call "newEditorDoc", Session.get('current_project'), tpl.$("input[name=name]").val(), tpl.$("textarea[name=desc]").val(), (err, res) ->
      if res
        miradorFunctions.mirador_viewer_loadView 'editorView',
          fileCabinetId: res
        tpl.$('#newDocModal').modal('hide')

  'hidden.bs.modal': (e, tpl) ->
    Blaze.remove tpl.view
