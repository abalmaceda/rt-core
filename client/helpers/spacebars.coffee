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