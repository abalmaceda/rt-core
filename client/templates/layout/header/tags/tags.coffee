Template.headerTags.helpers
	tagsComponent: ->
		# TODO 
		return Template.tagInputForm
		# If we're an admin with the header in edit mode, we display
		# the tag edit form, else the normal header tag links
		# if isEditing(currentTag()) and RealTimeCore.hasOwnerAccess()
		# 	return Template.tagInputForm
		# else
		# 	return Template.headerLinks