Template.header.helpers
	availableProjects: ->
		console.log Session.get "currentProject"
		projects = Projects.find({permissions: {$elemMatch: {user: Meteor.userId()}}})
		return projects