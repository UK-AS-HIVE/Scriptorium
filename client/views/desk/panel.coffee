Template.deskPanel.events

  "click .js-close-panel": ->
    $('.desk-document-panel').removeClass('is-open');

Template.savePanel.events

  "click .js-close-panel": ->
    $('.desk-save-panel').removeClass('is-open');

  "click #saveAsProject": ->
    if $("#newGroupName").val() != ""

      name = $("#newGroupName").val()
      workspaces = Workspaces.find("user": Meteor.userId(), "project": Session.get("current_project")).fetch()

      Meteor.call("saveNewProject", name, Meteor.userId(), workspaces, (err, data) ->
        Session.set "current_project", data
        $('.desk-save-panel').removeClass('is-open');
        Router.go "collaboration"
      )