Template.productDetail.helpers
	###
	# 	Retorna el Template de descripciòn de los Tags dependiendo si es propietario o no
	# @return [Template]
	# @todo Mejorar descripcion, hablar de los Templates
	###
	tagsComponent: ->
		if RealTimeCore.hasOwnerAccess()
			return Template.productTagInputForm
		else
			return Template.productDetailTags
			
	###
	# 	Retorna el Template dependiendo de los permisos del usuario
	# @param field [type] description
	# @return [Template]
	# @todo Mejorar descripcion, hablar de los Templates. Definir parametro FIELD
	###
	fieldComponent: (field) ->
		if RealTimeCore.hasOwnerAccess()
			return Template.productDetailEdit
		else
			return Template.productDetailField

	###
	# 	Retorna el Template dependiendo de los permisos del usuario
	# @return [Template]
	# @todo Mejorar descripcion, hablar de los Templates
	###
	metaComponent: () ->
		if RealTimeCore.hasOwnerAccess()
			return Template.productMetaFieldForm
		else
			return Template.productMetaField

	###
	#	Obtener el precio real del producto seleccionado
	# @note Es importante estar seguto de que la Variant seleccionada esta disponible para comprar. De otra manera, se muestra el rango de precios de todas las Variant existentes.
	# @return [String] Precio o rango de precios según corresponda
	###
	actualPrice: () ->
		current = selectedVariant()
		# Determinar si la Variant selecionada esta disponible para comprar.
		product = selectedProduct()
		if product and current
			childVariants = (variant for variant in product.variants when variant?.parentId is current._id)
			purchasable = if childVariants.length > 0 then false else true
		# Is una Variant disponible para compra, o una Option esta seleccionada, mostrar su precio.
		if purchasable
			return current.price
		# De otra manera mostrar el rango de precios de total de Variant agregadas.
		else
			return getProductPriceRange()