Template.productMetaFieldForm.events
	###
	# 	Elimina el meta component correspondiente
	# @note En el lado del servidor se verifica si el usuario tiene los permisos para realizar la eliminación
	# @option option [type] name description
	# @event name [Click]
	# 	Event tags
	# @param event [Event] description
	# @param template [Template.metaComponent] metaComponent de donde se gatilla el evento
	###
	'click .metafield-remove': (event,template) ->
		productId = selectedProductId()
		Products.update(productId, {$pull:{ metafields: @ }})

Template.metaComponent.events
	###
	# 	Graba los cambios en los campos simplemente cambiando el foco.
	# @note Se guarda automaticamente. No es necesario presionar un boton guardar.
	# @event name [description]
	# 	Event tags
	# @param event [Event] Información de los elemntos DOM del contexto
	# @param template [Template] Template que ejecuto el evento
	# @todo Comentar código
	###
	'change input': (event,template) ->
		#Recupera los valores de los campos
		updateMeta =
			key: $(event.currentTarget).parent().children('.metafield-key-input').val()
			value: $(event.currentTarget).parent().children('.metafield-value-input').val()
		if @.key
			productId = selectedProductId()
			Meteor.call "updateMetaFields", productId, updateMeta, @
			$(event.currentTarget).animate({backgroundColor: "#e2f2e2" }).animate({backgroundColor: "#fff"})
			Tracker.flush()
		else
			if updateMeta.value and not updateMeta.key
				$(event.currentTarget).parent().children('.metafield-key-input').val('').focus()
			if updateMeta.key and updateMeta.value
				Meteor.call "updateMetaFields", @._id, updateMeta
				Tracker.flush()
				$(event.currentTarget).parent().children('.metafield-key-input').val('').focus()
				$(event.currentTarget).parent().children('.metafield-value-input').val('')
			else
				return
