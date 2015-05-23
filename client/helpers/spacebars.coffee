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