Template.productDetailTags.helpers
	###
	# 	
	# @example (title)
	# @note message
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see link/reference
	# @throw message
	# @todo Agregar todo:
	###
	currentHashTag: () ->
		if selectedProduct()?.handle is @.name.toLowerCase()
			return true

Template.productTagInputForm.helpers
	###
	# 	
	# @example (title)
	# @note message
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see link/reference
	# @throw message
	# @todo Agregar todo:
	###
	hashtagMark: () ->
		if selectedProduct()?.handle is @.name.toLowerCase()
			return "fa-bookmark"
		else
			return "fa-bookmark-o"

Template.productTagInputForm.events
	###
	# 	
	# @example (title)
	# @note message
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see link/reference
	# @throw message
	# @todo Agregar todo:
	###
	'click .tag-input-hashtag': (event,template) ->
		Meteor.call "setHandleTag", selectedProductId(), @._id, (error,result) ->
		if result then Router.go "product", "_id": result

	###
	# 	
	# @example (title)
	# @note message
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see link/reference
	# @throw message
	# @todo Agregar todo:
	###
	'click .tag-input-group-remove': (event,template) ->
		Meteor.call "removeProductTag", selectedProductId(), @._id

	###
	# 	
	# @example (title)
	# @note message
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see link/reference
	# @throw message
	# @todo Agregar todo:
	###
	'click .tags-input-select': (event,template) ->
		$(event.currentTarget).autocomplete(
			delay: 0
			autoFocus: true
			source: (request, response) ->
				datums = []
				slug = getSlug request.term
				Tags.find({slug: new RegExp(slug, "i")}).forEach (tag) ->
					datums.push(
						label: tag.name
					)
				response(datums)
		)
		Tracker.flush()

	###
	# 	
	# @example (title)
	# @note message
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see link/reference
	# @throw message
	# @todo Agregar todo:
	###
	'blur.autocomplete, change .tags-input-select': (event,template) ->
		val = $(event.currentTarget).val()
		if val
			currentTag = Session.get "currentTag"
			Meteor.call "updateProductTags", selectedProductId(), val, @._id, currentTag, (error, result) ->
				if error
					console.log "Error updating header tags", error
				Tracker.flush()
				template.$('.tags-submit-new').val('').focus();

	###
	# 	
	# @example (title)
	# @note message
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see link/reference
	# @throw message
	# @todo Agregar todo:
	###
	'mousedown .tag-input-group-handle': (event,template) ->
		Tracker.flush()
		template.$(".tag-edit-list").sortable("refresh")

Template.productTagInputForm.rendered = ->
	###
	# 	
	# @example (title)
	# @note Inline field editing, handling
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see http://vitalets.github.io/x-editable/docs.html
	# @throw message
	# @todo Agregar todo:
	###
	$(".tag-edit-list").sortable
		items: "> li"
		handle: '.tag-input-group-handle'
		update: (event, ui) ->
			hashtagsList = []
			uiPositions = $(@).sortable("toArray", attribute:"data-tag-id")
			for tag,index in uiPositions
				if tag then hashtagsList.push tag

			Products.update(selectedProductId(), {$set: {hashtags: hashtagsList}})