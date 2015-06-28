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

###
#	@param name [type] 
#	@return [type]
# Returns all enabled+dashboard package registry objects
# *optional* options for filtering are:
#   provides="<where matching registry provides is this >"
#   enabled=true <false for disabled packages>
#   context= true filter templates to current route
#
#	@todo
#   - reintroduce a dependency context
#   - introduce position,zones #148
#   - is it better to get all packages once and filter in code
#     and possibly have some cache benefits down the road,
#     or to retrieve what is requested and gain the advantage of priviledged,
#     unnecessary data not retrieved with the cost of additional requests.
#   - context filter should be considered experimental
#
###
Template.registerHelper "reactionApps", (options) ->
	reactionApps = []
	filter = {}
	registryFilter = {}
	# any registry property, name, enabled can be used as filter
	for key, value of options.hash
		unless key is 'enabled' or key is 'name'
			filter['registry.' + key] = value #for query
			registryFilter[key] = value #for registry filter
		else
			filter[key] = value #handle top level filters

	# we only need these fields (filtered for user, all available to admin)
	fields =
	'enabled': 1
	'registry': 1
	'name': 1

	# fetch filtered package
	reactionPackages = RealTimeCore.Collections.Packages.find(filter, fields).fetch()

	# really, this shouldn't ever happen
	unless reactionPackages then throw new Error("Packages not loaded.")

	# filter packages
	# this isn't as elegant as one could wish, review, refactor?

	#  filter name and enabled as the package level filter
	if filter.name and filter.enabled
		packages = (pkg for pkg in reactionPackages when pkg.name is filter.name and pkg.enabled is filter.enabled)
	else if filter.name
		packages = (pkg for pkg in reactionPackages when pkg.name is filter.name)
	else if filter.enabled
		packages = (pkg for pkg in reactionPackages when pkg.enabled is filter.enabled)
	else
		packages = (pkg for pkg in reactionPackages)

	# filter and reduce, format registry objects
	# checks to see that all registry filters are applied to the registry objects
	# and pushes to reactionApps
	for app in packages
		for registry in app.registry
			match = 0
			for key, value of registryFilter
				if registry[key] is value
					match += 1
				if match is Object.keys(registryFilter).length
					registry.name = app.name
					registry.enabled = app.enabled
					registry.packageId = app._id
					reactionApps.push registry

	#
	# TODO:
	# add group by provides, sort by cycle, enabled
	#

	# make sure they are unique
	reactionApps = _.uniq(reactionApps)
	return reactionApps
