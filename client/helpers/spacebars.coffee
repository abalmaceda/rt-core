###
#	general helper for determine if user has a store
# 	@message 
#	@return [bool]
###
Template.registerHelper "userHasProfile", ->
	user = Meteor.user()
	return user and !! user.profile.store

###
#	General helper for determine if user has a store
# 	@message 
#	@param role [String] Role que se desea consultar en el usuario
#	@return [bool] 
###
Template.registerHelper "userHasRole", (role) ->
	user = Meteor.user()
	return user and user.roles.indexOf(role) isnt -1  if user and user.roles

#
# return path for route
#
###
# ---TODO---
#	
# 	@message 
#	@param name [type] 
#	@return [type]
###
Template.registerHelper "pathForSEO", (path, params) ->
	if this[params]
		return "/"+ path + "/" + this[params]
	else
		return Router.path path,this


###
# ---TODO---
# methods to return cart calculated values
# cartCount, cartSubTotal, cartShipping, cartTaxes, cartTotal
# are calculated by a transformation on the collection
# and are available to use in template as cart.xxx
# in template: {{cart.cartCount}}
# in code: ReactionCore.Collections.Cart.findOne().cartTotal()
###
Template.registerHelper "cart", () ->
	###
	# ---TODO---
	#	return true if there is an issue with the user's cart and we should display the warning icon
	# 	@message 
	#	@param name [type] 
	#	@return [type]
	###
	showCartIconWarning: ->
		if @.showLowInventoryWarning()
			return true
		return false

	###
	# ---TODO---
	#	return true if any item in the user's cart has a low inventory warning
	# 	@message 
	#	@param name [type] 
	#	@return [type]
	###
	showLowInventoryWarning: ->
		storedCart = Cart.findOne()
		if storedCart?.items
			for item in storedCart?.items
				if item.variants?.inventoryPolicy and item.variants?.lowInventoryWarningThreshold
					if (item.variants?.inventoryQuantity <= item.variants.lowInventoryWarningThreshold)
						return true
		return false

# # return true if item variant has a low inventory warning
# showItemLowInventoryWarning: (variant) ->
# if variant?.inventoryPolicy and variant?.lowInventoryWarningThreshold
# if (variant?.inventoryQuantity <= variant.lowInventoryWarningThreshold)
# return true
# return false



###
#  General helpers for template functionality
###

###
#	conditional template helpers
#	@example Hacer una consulta
#		{{#if condition status "eq" ../value}}
# 	@message 
#	@param name [type] 
#	@return [type]
###
Template.registerHelper "condition", (v1, operator, v2, options) ->
	switch operator
		when "==", "eq"
			v1 is v2
		when "!=", "neq"
			v1 isnt v2
		when "===", "ideq"
			v1 is v2
		when "!==", "nideq"
			v1 isnt v2
		when "&&", "and"
			v1 and v2
		when "||", "or"
			v1 or v2
		when "<", "lt"
			v1 < v2
		when "<=", "lte"
			v1 <= v2
		when ">", "gt"
			v1 > v2
		when ">=", "gte"
			v1 >= v2
		else
			throw "Undefined operator \"" + operator + "\""

###
#	
#	@todo
# 	@message 
#	@param name [type] 
#	@return [type]
###
Template.registerHelper "orElse", (v1, v2) ->
  return v1 || v2
