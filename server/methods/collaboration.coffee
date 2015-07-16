Meteor.methods({
  removeUserFromProject: (projectId, userId) ->
    Projects.update({_id: projectId},
                    {$pull: {permissions: {user: userId}}})

  addUserToProject: (projectId, email, role) ->
    person = Meteor.users.findOne({"emails.address": email})

    #check to make sure this is an admin user
    project = Projects.findOne({
      _id: projectId,
      permissions: {$elemMatch: {user: @userId, level: 'admin'}}
    })

    if !person
      throw new Meteor.Error("User not found")

    if !project
      throw new Meteor.Error("You do not have permission")

    userAlreadyIn = _.any(project.permissions, (p) ->
      p.user == person._id)

    if userAlreadyIn
      throw new Meteor.Error("User is already in the project")

    Projects.update({_id: project._id},
                    {$addToSet: {permissions: {user: person._id, level: role}}})

  editUserInProject: (projectId, userId, role) ->
    #check to make sure this is an admin user
    project = Projects.findOne({
      _id: projectId,
      permissions: {$elemMatch: {user: @userId, level: 'admin'}}
    })

    if !project
      throw new Meteor.Error("Access Denied")

    if !_.any(project.permissions, (p) -> p.user == userId)
      throw new Meteor.Error("User In Not In Project")

    Meteor.call('removeUserFromProject', projectId, userId)
    Projects.update({_id: projectId},
                    {$addToSet: {permissions: {user: userId, level: role}}})


  saveNewProject: (name, uid, workspaces) ->
    newProject = {}
    newProject.projectName = name
    newProject.permissions = []
    newProject.miradorData = []
    newProject.permissions.push {"level": "admin", "user": uid}

    newProjectId = Projects.insert newProject
    newProjectId
})
