Template.savePanel.events

  "click .js-close-panel": ->
    $('.desk-save-panel').removeClass('is-open')

  "click #saveAsProject": ->
    # process -> get new project ID -> share manifests with new project ID -> put new manifest ID's in new project

    if $("#newGroupName").val() != ""

      name = $("#newGroupName").val()
      workspaces = Workspaces.find("user": Meteor.userId(), "project": Session.get("current_project")).fetch()

      # got a new prohect ID
      Meteor.call("saveNewProject", name, Meteor.userId(), workspaces, (err, data) ->

        for space in workspaces
          if space.widgets.length > 0
            uri = space.manifestUri.split("/manifest/")
            id = uri[1].split("/")
            mani = AvailableManifests.findOne({"_id": id[0]})
            newMani = {}
            newMani.location = mani.manifestLocation
            newMani.payload = mani.manifestPayload
            newMani.title = mani.manifestTitle

            Meteor.call("shareManifests", Meteor.userId(), data, newMani, space.widgets, (err, data) ->
              Meteor.call("addDataToProject", data.project, data.id, data.widgets)
            )

        Session.set "current_project", data
        $('.desk-save-panel').removeClass('is-open')
        Router.go "collaboration"
      )


