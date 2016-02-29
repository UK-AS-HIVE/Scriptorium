# TODO: Cloning desk configuration, if desired:

Template.createProjectModal.events
  'click button[data-action=save]': (e, tpl) ->
    name = tpl.$('input[name=projectName]').val()
    Meteor.call 'saveNewProject', name, [], (err, res) ->
      Session.set 'current_project', res
      tpl.$('#createProjectModal').modal('hide')
   
  'hidden.bs.modal': (e, tpl) -> Blaze.remove tpl.view

