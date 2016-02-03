Meteor.methods
  removeUserFromProject: (projectId, userId) ->
    project = Projects.findOne {
      _id: projectId,
      permissions: { $elemMatch: { user: @userId, level: 'admin' } }
    }
    if project or (userId is @userId)
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
      throw new Meteor.Error("User to be added to project not found")

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

    if !project
      throw new Meteor.Error("Access Denied")

    if !_.any(project.permissions, (p) -> p.user == userId)
      throw new Meteor.Error("User In Not In Project")

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
