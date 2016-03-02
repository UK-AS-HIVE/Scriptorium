Meteor.miradorFunctions =
  loadMirador:() ->
    #clear old mirador components
    # $(".mirador-viewer").remove()
    # $(".mirador-main-menu-bar").remove()
    # $(".mirador-status-bar").remove()
    $("[class^='mirador']").remove()

    thisObject = {"id": "viewer", "data": []}
    currentProject = Session.get("current_project")
    if currentProject == "Free Space"
      myMani = AvailableManifests.find({$or: [{"project": "Default", "user": "Default"}, {"project": "Free Space", "user": Meteor.userId()}]}).fetch()
    else
      myMani = AvailableManifests.find({$or: [{"project": "Default", "user": "Default"}, {"project": currentProject}]}).fetch()
    root = Meteor.absoluteUrl()

    for item in myMani
      maniUri = root + "manifest/" + item["_id"] + "/" + Session.get("current_project")
      workspaces = Workspaces.find({"manifestUri": maniUri, "project": Session.get("current_project"), "user": Meteor.userId()}).fetch()
      if workspaces.length > 0
        widgets = workspaces[0].widgets
      else
        #this is a new login/project
        if Session.get("current_project") == "Free Space"
          widgets = []
        else
          #get current project info
          thisProject = Projects.find({"_id": Session.get("current_project")}).fetch()
          for data in thisProject[0].miradorData
            if data.manifestId == item["_id"]
              widgets = data.widgets


      thisObject["data"].push({"manifestUri": maniUri, "location": item["manifestLocation"], "title": item["manifestTitle"], "widgets": widgets})
    Mirador thisObject
