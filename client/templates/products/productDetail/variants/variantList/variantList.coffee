Template.variantList.helpers
	###
	# ---TODO---
	# @param
	###
	variants: () ->
		product = selectedProduct()
		if product
			# Obtener un arreglo con los variants que no tienen parentId
			# ---TODO--- 
			#Averiguar si solo puede haber un variant sin parentId
			variants = (variant for variant in product.variants when !variant.parentId?)

			inventoryTotal = 0
			for variant in variants
				unless isNaN(variant.inventoryQuantity)
					inventoryTotal +=  variant.inventoryQuantity
			for variant in variants
				@variant
				variant.inventoryTotal = inventoryTotal
				variant.inventoryPercentage = parseInt((variant.inventoryQuantity / inventoryTotal) * 100)
				variant.inventoryWidth = parseInt((variant.inventoryPercentage - variant.title?.length ))
			variants