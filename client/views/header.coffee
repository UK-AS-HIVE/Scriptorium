Template.header.rendered = () ->
	Tracker.autorun(() ->
		projects = Projects.find({permissions: {$elemMatch: {user: Meteor.userId()}}}).fetch()

		#If there is no current_project selected grab the first one
		# and make it that one
		if !Session.get('current_project') && projects && projects.length > 0
			Session.set('current_project', projects[0]._id)
	)

Template.header.helpers
	availableProjects: ->
		projects = Projects.find({permissions: {$elemMatch: {user: Meteor.userId()}}})
		return projects

	isCurrentProject: (projectId) ->
		Session.get('current_project') == projectId

Template.header.events({
	"change #projectSelector": (e) ->
	  projId = $(e.target).val()
	  Session.set("current_project", projId)
})
