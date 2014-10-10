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

})
