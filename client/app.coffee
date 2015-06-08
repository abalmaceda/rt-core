###
# Global reaction shop permissions methods and shop initialization
###
_.extend RealTimeCore,
	shopId: null
	isMember: false
	isOwner: null
	isAdmin: null
	userPermissions: []
	shopPermissions: []
	shopPermissionGroups: []
	init: ->
		self = @

	###
    #	Role Checkout
	#	@return [bool] si tiene acceso de Owner
	###
	hasOwnerAccess: ->
		return Roles.userIsInRole(Meteor.user(), "admin") or @isOwner

	###
    #	dashboard access
	#	@return [bool] dashboard access
	###
	hasDashboardAccess: ->
		return @isMember or @.hasOwnerAccess()