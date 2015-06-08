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
# Reaction Server / amplify permanent sessions
# If no id is passed we create a new session
# Load the session
# If no session is loaded, creates a new one
###

###
# ---TODO---
#	products
# @param
### 
@ServerSessions = new Mongo.Collection("Sessions")
Meteor.publish 'Sessions', (id) ->
	check id, Match.OneOf(String, null)

	created = new Date().getTime()
	id = ServerSessions.insert(created: created) unless id
	serverSession = ServerSessions.find(id)

	if serverSession.count() is 0
		id = ServerSessions.insert(created: created)
		serverSession = ServerSessions.find(id)
	return serverSession


###
#  Packages contains user specific configuration
#  settings, package access rights
###
Meteor.publish "Packages", ->
	shop = RealTimeCore.getCurrentShop(this)
	if shop
		if Roles.userIsInRole(this.userId, ['dashboard','owner','admin'])
			return Packages.find shopId: shop._id
		else
			# settings.public published
			# other access to settings,etc is blocked
			# for non administrative views
			return Packages.find { shopId: shop._id},
				fields:
					name: true
					enabled: true
					registry: true
					shopId: true
					'settings.public': true
					# TODO Filter roles/security here for package routes/template access.
	else
		return []

###
# shops
###
Meteor.publish 'shops', ->
	RealTimeCore.getCurrentShopCursor(@)



###
# ---TODO---
#	products
# @param
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

###
# ---TODO---
# @param
### 
Meteor.publish 'product', (productId) ->
	return Products.find({})
	# check productId, String
	# shop = RealTimeCore.getCurrentShop(@) #todo: wire in shop
	# if productId.match /^[A-Za-z0-9]{17}$/
	# 	return Products.find(productId)
	# else
	# 	return Products.find({handle: { $regex : productId, $options:"i" } })


###
# ---TODO---
# @param
### 
Meteor.publish "tags", ->
	return Tags.find({})
	#return Tags.find(shopId: RealTimeCore.getShopId())