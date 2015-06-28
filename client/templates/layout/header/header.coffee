###
# ---TODO---
###
Template.layoutHeader.events
	###
	# ---TODO---
	# 	@message 
	#	@param event [type] 
	#	@return [type]
	###
	'click .navbar-accounts .dropdown-toggle': () ->
		setTimeout (->
			$("#login-email").focus()
		), 100
	###
	#clears dashboard active links. needs a better approach.
	#---TODO---
	#	@message 
	#	@param event [type] 
	#	@return [type]
	###
	'click .header-tag, click .navbar-brand': () ->
		$('.dashboard-navbar-packages ul li').removeClass('active')
