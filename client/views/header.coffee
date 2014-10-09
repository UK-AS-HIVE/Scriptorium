Template.header.helpers
	availableProjects: ->
		console.log Session.get "currentProject"
		projects = Projects.find({permissions: {$elemMatch: {user: Meteor.userId()}}})
		return projects

Template.header.events({
	"change #projectSelector": (e) ->
	  projId = $(e.target).val()
	  Session.set("current_project", projId)
})
