###
# get price range of a product
# if no only one price available, return it
###
@getProductPriceRange = (productId) ->
	# if no productId provided, use currently selected
	product = Products.findOne(productId || selectedProduct()._id )
	productId = product?._id

	# let's leave if nothing can be used
	return unless productId

	variants = (variant for variant in product.variants when not variant.parentId)

	if variants.length > 0
		variantPrices = []
		for variant in variants
			range = getVariantPriceRange(variant._id, productId)
			if Match.test range, String
				firstPrice = parseFloat range.substr 0, range.indexOf(" ")
				lastPrice = parseFloat range.substr range.lastIndexOf(" ") + 1
				variantPrices.push firstPrice, lastPrice
			else
				variantPrices.push range

		priceMin = _.min variantPrices
		priceMax = _.max variantPrices
		if priceMin is priceMax
			return priceMin
		return priceMin + ' - ' + priceMax

###
# get price range of a variant if it has child options.
# if no child options, return main price value
###
@getVariantPriceRange = (variantId, productId) ->
	productId = productId || selectedProductId()
	variantId = variantId || selectedVariant()._id

	product = Products.findOne(productId, )

	# we want to prevent this from running without valid params
	unless variantId and productId and product then return

	variant = _.findWhere product.variants, _id: variantId

	children = (thisVariant for thisVariant in product.variants when thisVariant.parentId is variantId)

	if children.length is 0
		if variant?.price
			return variant.price
		else
			return

	if children.length is 1
		return children[0].price

	priceMin = Number.POSITIVE_INFINITY
	priceMax = Number.NEGATIVE_INFINITY

	for child in children
		priceMin = child.price if child.price < priceMin
		priceMax = child.price if child.price > priceMax

	if priceMin is priceMax
		return priceMin
	return priceMin + ' - ' + priceMax