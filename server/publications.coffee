Cart			= RealTimeCore.Collections.Cart
Accounts		= RealTimeCore.Collections.Accounts
Discounts		= RealTimeCore.Collections.Discounts
Media			= RealTimeCore.Collections.Media
Orders			= RealTimeCore.Collections.Orders
Packages		= RealTimeCore.Collections.Packages
products 		= RealTimeCore.Collections.Products
Shipping 		= RealTimeCore.Collections.Shipping
Shops 			= RealTimeCore.Collections.Shops
Tags 			= RealTimeCore.Collections.Tags
Taxes 			= RealTimeCore.Collections.Taxes
Translations 	= RealTimeCore.Collections.Translations









###
# products
###
Meteor.publish 'products', (userId, shops) ->
	return Products.find({})
	# shop = RealTimeCore.getCurrentShop(@)
	# if shop
	# 	selector = {shopId: shop._id}
	# 	## add additional shops
	# 	if shops
	# 		selector = {shopId: {$in: shops}}
	# 	unless Roles.userIsInRole(this.userId, ['admin'])
	# 		selector.isVisible = true
	# 	return Products.find(selector)
	# else
 #    	return []

Meteor.publish 'product', (productId) ->
	return Products.find(productId)
	# check productId, String
	# shop = ReactionCore.getCurrentShop(@) #todo: wire in shop
	# if productId.match /^[A-Za-z0-9]{17}$/
	# 	return Products.find(productId)
	# else
	# 	return Products.find({handle: { $regex : productId, $options:"i" } })