###
# general helper for determine if user has a store
# returns boolean
###
Template.registerHelper "userHasProfile", ->
  user = Meteor.user()
  return user and !!user.profile.store

Template.registerHelper "userHasRole", (role) ->
  user = Meteor.user()
  return user and user.roles.indexOf(role) isnt -1  if user and user.roles


#
# return path for route
#
Template.registerHelper "pathForSEO", (path, params) ->
  if this[params]
    return "/"+ path + "/" + this[params]
  else
    return Router.path path,this

###
#  General helpers for template functionality
###

###
# conditional template helpers
# example:  {{#if condition status "eq" ../value}}
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