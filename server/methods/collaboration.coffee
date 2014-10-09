Meteor.methods({
  removeUserFromProject: (projectId, userId) ->
    Projects.update({_id: projectId},
                    {$pull: {permissions: {user: userId}}})
})
