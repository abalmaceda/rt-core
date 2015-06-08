Template.productDetailTags.helpers
	currentHashTag: () ->
		if selectedProduct()?.handle is @.name.toLowerCase()
			return true