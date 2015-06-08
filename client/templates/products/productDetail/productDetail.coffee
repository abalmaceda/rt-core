Template.productDetail.helpers

	###
	#	Retorna el Template de descripciòn de los Tags dependiendo si es propietario o no
	#	@return [Template] 
	###
	tagsComponent: ->
		if RealTimeCore.hasOwnerAccess()
			return Template.productTagInputForm
		else
			return Template.productDetailTags
			
	###
	# ---TODO---
	# @param
	###	
	fieldComponent: (field) ->
		if RealTimeCore.hasOwnerAccess()
			return Template.productDetailEdit
		else
			return Template.productDetailField

	###
	# ---TODO---
	#	Get the actual price of the selected Product
	# 	@message Is important to be sure that the salected variant is purchasable. Otherwise, we show price range a full variant set.
	#	@return []
	###
	actualPrice: () ->
		current = selectedVariant()
		# determine if selected variant is purchasable
		product = selectedProduct()
		if product and current
			childVariants = (variant for variant in product.variants when variant?.parentId is current._id)
			purchasable = if childVariants.length > 0 then false else true
	    # if a purchasable variant or option is selected, show its price
		if purchasable
			return current.price
	    # otherwise show price range of full variant set
		else
			return getProductPriceRange()