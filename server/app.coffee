###
# configure bunyan logging module for realTime server
# See: https://github.com/trentm/node-bunyan#levels
###
isDebug = Meteor.settings.isDebug
LOG_PATH = Meteor.settings.LOG_PATH
# acceptable levels
levels = ["FATAL","ERROR","WARN", "INFO", "DEBUG", "TRACE"]

#
# if debug is true, or NODE_ENV development environment and not false
# set to lowest level, or any defined level set to level
#
if isDebug is true or ( process.env.NODE_ENV is "development" and isDebug isnt false )
  # set logging levels from settings
  if typeof isDebug isnt 'boolean' and typeof isDebug isnt 'undefined' then isDebug = isDebug.toUpperCase()
  unless _.contains levels, isDebug
    isDebug = "WARN"

  unless typeof LOG_PATH is 'string' then LOG_PATH = "/var/tmp/foo.log"
   
# Define bunyan levels and output to Meteor console
RealTimeCore.Events = logger.bunyan.createLogger(
  name: "rtcommerce:core"
  serializers: logger.bunyan.stdSerializers
  streams: [
    {
      level: "debug"
      stream: (unless isDebug is "DEBUG" then logger.bunyanPretty() else process.stdout )
    }
    {
      level: "info"
      path: LOG_PATH # log ERROR and above to a file
    }
  ]
)
# set bunyan logging level
RealTimeCore.Events.level(isDebug)

RealTimeCore.Events.trace {isDebug:isDebug}

# RealTimeCore.Events.on('error', (err, stream) ->
#   RealTimeCore.Events.info "testing new things for me"
# );

###
# Global realTime shop permissions methods
###
_.extend RealTimeCore,
  getCurrentShopCursor: (client) ->
    domain = @getDomain(client)
    cursor = Shops.find({domains: domain}, {limit: 1})
    if !cursor.count()
      RealTimeCore.Events.info "RealTime Configuration: Add a domain entry to shops for: ", domain
    return cursor

  getCurrentShop: (client) ->
    cursor = @getCurrentShopCursor(client)
    return cursor.fetch()[0]

  getShopId: (client) ->
    return @getCurrentShop(client)._id

  getDomain: (client) ->
    #todo: eventually we want to use the host domain to determine
    #which shop from the shops collection to use here, hence the unused client arg
    return Meteor.absoluteUrl().split('/')[2].split(':')[0]

  findMember: (shop, userId) ->
    shop = @getCurrentShop() unless shop
    userId = Meteor.userId() unless userId
    return _.find shop.members, (member) ->
      userId is member.userId

  hasPermission: (permissions, shop, userId) ->
    return false unless permissions
    shop = @getCurrentShop() unless shop
    userId = Meteor.userId() unless userId
    permissions = [permissions] unless _.isArray(permissions)
    has = @hasOwnerAccess(shop, userId)
    unless has
      member = @findMember(shop, userId)
      if member
        has = member.isAdmin or _.intersection(permissions, member.permissions).length
    return has

    ###
    #	Verifica si el usuario tiene acceso de propietario
    #	@todo Verificar tipo del parametro shop
	#	@param shop [] 
	#	@param userId [string] Id del usuario que se desea consultar
	#	@return [bool] si tiene acceso de Owner
	###
	hasOwnerAccess: (shop, userId) ->
		shop = @getCurrentShop() unless shop
		userId = Meteor.userId() unless userId
		return Roles.userIsInRole(userId, "admin") or userId is shop.ownerId

  canCheckoutAsGuest = (client) ->
    return @getCurrentShop(client).canCheckoutAsGuest || false
