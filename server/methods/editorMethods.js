Meteor.methods({
	saveEditorDoc: function(editorData){

		console.log(editorData);

	},

	getNewEditorId: function(user, project, title){
		console.log("new editor instance requested");
		var newEditorID = FileCabinet.insert({
			'project': project,
			'fileType': 'editor',
			'user': user,
			'date': new Date(),
			'content': "",
			'open': true,
			'title': title
		});
		return newEditorID;
	}

})