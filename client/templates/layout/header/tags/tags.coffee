###
# ---TODO---
###
isMovingTag = false

###
# ---TODO---
###
isEditing = (id) ->
	return Session.equals "isEditing-"+id, true

###
# ---TODO---
###
currentTag = ->
	return Session.get "currentTag"

###
# ---TODO---
###
Template.headerTags.helpers
	tagsComponent: ->
		# If we're an admin with the header in edit mode, we display
		# the tag edit form, else the normal header tag links
		if isEditing(currentTag()) and RealTimeCore.hasOwnerAccess()
			return Template.tagInputForm
		else
			return Template.headerLinks

###
# ---TODO---
###
Template.headerLinks.helpers
	activeTag: ->
		return "active" if Session.equals "currentTag", @._id

###
# ---TODO---
###
Template.tagInputForm.helpers
	tags: ->
		tagList = []
		for tag in @.tags
			tagList.push tag._id
		return tagList.toString()

###
# ---TODO---
###
Template.tagInputForm.rendered = ->
	# *****************************************************
	# Inline field editing, handling
	# http://vitalets.github.io/x-editable/docs.html
	# *****************************************************
	$(".tag-edit-list").sortable
		items: "> li"
		axis: "x"
		handle: '.tag-input-group-handle'
		update: (event, ui) ->
			uiPositions = $(@).sortable("toArray", attribute:"data-tag-id")
			for tag,index in uiPositions
				Tags.update tag, {$set: {position: index}}
		stop: (event, ui) ->
			isMovingTag = false