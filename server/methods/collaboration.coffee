Meteor.methods
  removeUserFromProject: (projectId, userId) ->
    project = Projects.findOne {
      _id: projectId,
      permissions: { $elemMatch: { user: @userId, level: 'admin' } }
    }
    admins = _.countBy project.permissions, (i) ->
      i.level is 'admin'
    if (userId is @userId) and (admins.true is 1) and !admins.false
      # TODO: Can we delete projects? Is there any reason to keep around projects with no users?
      throw new Meteor.Error("Removing yourself would leave no users in the project - please delete the project if you wish to remove youself.")
    if (userId is @userId) and (admins.true is 1)
      throw new Meteor.Error("There are no other administrators in the project; please designate another administrator before removing yourself.")
    else if project or (userId is @userId)
      Projects.update projectId, { $pull: { permissions: { user: userId } } }
    else
      throw new Meteor.Error("User lacks permission to remove user from project")

  addUserToProject: (projectId, email, role) ->
    person = Meteor.users.findOne({"emails.address": email})

    # check to make sure this is an admin user
    project = Projects.findOne {
      _id: projectId,
      permissions: {$elemMatch: {user: @userId, level: 'admin'}}
    }

    if !person
      throw new Meteor.Error("User not found")

    if !project
      throw new Meteor.Error("User lacks permission to add user to project")

    userAlreadyIn = _.any project.permissions, (p) ->
      p.user is person._id

    if userAlreadyIn
      throw new Meteor.Error("User is already in the project")

    Projects.update project._id,
      { $addToSet: { permissions: { user: person._id, level: role } } }

  editUserInProject: (projectId, userId, role) ->
    # check to make sure this is an admin user
    project = Projects.findOne {
      _id: projectId,
      permissions: {$elemMatch: {user: @userId, level: 'admin'}}
    }

    admins = _.countBy project.permissions, (i) ->
      i.level is 'admin'
    if (userId is @userId) and (admins.true is 1)
      throw new Meteor.Error("There are no other administrators in the project; please designate another administrator before removing yourself.")

    if !project
      throw new Meteor.Error("Access Denied")

    if !_.any(project.permissions, (p) -> p.user == userId)
      throw new Meteor.Error("User not in project")

    Meteor.call 'removeUserFromProject', projectId, userId
    Projects.update projectId,
      { $addToSet: { permissions: { user: userId, level: role } } }


  saveNewProject: (name, uid, workspaces) ->
    newProject = {
      projectName: name
      permissions: [ { level: "admin", user: uid } ]
      miradorData: []
    }
    Projects.insert newProject
