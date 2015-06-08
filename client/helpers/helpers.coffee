
###
#  Reactive current product
#  This ensures reactive products, without session
#  products:
#  set usage: currentProduct.set "productId",string
#  get usage: currentProduct.get "productId"
#  variants:
#  set usage: currentProduct.set "variantId",string
#  get usage: currentProduct.get "variantId"
###
@currentProduct =
	keys: {}
	deps: {}
	equals: (key) ->
		@keys[key]
	get: (key) ->
	    @ensureDeps key
	    @deps[key].depend()
	    @keys[key]
	set: (key, value) ->
	    @ensureDeps key
	    @keys[key] = value
	    @deps[key].changed()
	changed: (key) ->
	    @ensureDeps key
	    @deps[key].changed()
	ensureDeps: (key) ->
		#Dependencies don't store data, they just track the set of computations
		#to invalidate if something changes. Typically, a data value will be 
		#accompanied by a Dependency object that tracks the computations that depend on it
		@deps[key] = new Tracker.Dependency unless @deps[key]

currentProduct = @currentProduct

@setCurrentVariant = (variantId) ->
	#Si se hace un unsetting, simplemente hacerlo
	if variantId is null
		currentProduct.set "variantId", null
		currentProduct.set "variantId", selectedVariantId()
	return unless variantId
	#si no se realiza un unsetting, obtener el actual varian ID
	currentId = selectedVariantId()
	#Solo se debe setear el variantId si es distinto al actual
	# En caso contrario, no es necesario realizar nada
	return if currentId is variantId
	#Setear nuevo valor
	currentProduct.set "variantId", variantId
	return

@setCurrentProduct = (productId) ->
	#Si se hace un unsetting, simplemente hacerlo
	if productId is null
		currentProduct.set "productId", null
	return unless productId
	#Obtenere el actual product ID si no se hace unsetting
	currentId = selectedProductId()
	#si se cambia el actual ID por otro, hacerlo
	# En caso contrario no es necesario realizar set.
	return if currentId is productId
	currentProduct.set "productId", productId
	# Limpiar el actual variant tambien
	currentProduct.set "variantId", null
	return

@selectedVariantId = ->
	id = currentProduct.get "variantId"
	return id if id?
	# default to top variant in selectedProduct
	product = selectedProduct()
	return unless product
	variants = (variant for variant in product.variants when not variant.parentId)
	return unless variants.length > 0
	id = variants[0]._id
	currentProduct.set "variantId", id
	return id


###
# get price range of a product
# if no only one price available, return it
###
@getProductPriceRange = (productId) ->
	# if no productId provided, use currently selected
	product = Products.findOne(productId || selectedProduct()._id )
	productId = product?._id

	# Abandonar si no hay nada que hacer
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

###
# 	Obtiene el product seleccionado
#	@return [Product] 
###
@selectedProduct = ->
	id = selectedProductId()
	return Products.findOne id

###
# 	Obtene el id del actual product
#	@return [String] id 
###
@selectedProductId = ->
	return currentProduct.get "productId"

###
#	TODO
###
@selectedVariant = ->
	id = selectedVariantId()
	return unless id
	product = selectedProduct()
	return unless product
	variant = _.findWhere product.variants, _id: id
	return variant

###
# Obtiene el variantId del producto actual. Si no esta definido, busca la variante "top" en el producto seleccionado
#	@return [String] id de la variant del product actual
###
@selectedVariantId = ->
	id = currentProduct.get "variantId"
	return id if id?
	# default to top variant in selectedProduct
	product = selectedProduct()
	return unless product
	variants = (variant for variant in product.variants when not variant.parentId)
	return unless variants.length > 0
	id = variants[0]._id
	# Before return id, set the "variantId" value in currentProduct
	currentProduct.set "variantId", id
	return id