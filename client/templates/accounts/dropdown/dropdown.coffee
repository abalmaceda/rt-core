###
# TODO
#
###
Template.loginDropdown.events
	###
	# ---TODO---
	# 	@message 
	#	@param event [type] 
	#	@return [type]
	###
	"click .dropdown-menu": (event) ->
		event.stopPropagation()

	###
	# ---TODO---
	# 	@message 
	#	@param event [type] 
	#	@return [type]
	###
	"click #logout": (event, template) ->
		Session.set 'displayConsoleNavBar', false
		Meteor.logout (err) ->
			Meteor._debug err if err
		event.preventDefault()
		template.$('.dropdown-toggle').dropdown('toggle') # close dropdown

	###
	# ---TODO---
	# 	@message 
	#	@param event [type] 
	#	@return [type]
	###
	"click .user-accounts-dropdown-apps a": (event, template) ->
		if @.route is "createProduct"
			event.preventDefault()
			Meteor.call "createProduct", (error, productId) ->
				if error
					console.log "createProduct error", error
				else if productId
					Router.go "product",
						_id: productId
					return
				return
		else if @.route
			event.preventDefault()
			template.$('.dropdown-toggle').dropdown('toggle') # close dropdown
			Router.go(@.route)
