Meteor.methods({
	saveEditorDoc: function(editorData){

		console.log(editorData);

	},

	getNewEditorId: function(user, project, title, desc){
		console.log("new editor instance requested");
		var newEditorID = FileCabinet.insert({
			'project': project,
			'fileType': 'editor',
			'user': user,
			'date': new Date(),
			'content': "",
			'open': true,
			'title': title,
			'description': desc

		});
		return newEditorID;
	},

	openDoc: function(user, project, docId){
		OpenDocs.insert({
			'user': user,
			'project': project,
			'document': docId
		});
	},

	closeDoc: function(user, project, docId){
		OpenDocs.remove({
			'user': user,
			'project': project,
			'document': docId
		});
	}

})