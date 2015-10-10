###
# Helper method to set default/parameterized product variant
###
setProduct = (productId, variantId) ->
	unless productId.match /^[A-Za-z0-9]{17}$/
    	product = Products.findOne({handle: productId.toLowerCase()})
    	productId = product?._id

  	setCurrentProduct productId
  	setCurrentVariant variantId
  	return

###
#  Global Route Configuration
#  Extend/override in realtime/client/routing.coffee
###
Router.configure
	notFoundTemplate: "notFound"
	loadingTemplate: "loading"
	onBeforeAction: ->
		@render "loading"
		#   Alerts.removeSeen()
		@next()
		return

# we always need to wait on these publications
Router.waitOn ->
	@subscribe "shops"
	@subscribe "Packages"


# general realtime controller
@ShopController = RouteController.extend
	# onAfterAction: ->
	# 	RealTimeCore.MetaData.refresh(@route, @params)
	# 	return
	layoutTemplate: "coreLayout"
	yieldTemplates:
		layoutHeader:
	  		to: "layoutHeader"
		layoutFooter:
		  	to: "layoutFooter"
			# dashboard:
			#   to: "dashboard"
# local ShopController
ShopController = @ShopController


###
# General Route Declarations
###
Router.map ->
# default index route, normally overriden parent meteor app
	@route "index",
	    controller: ShopController
	    path: "/"
	    name: "index"
	    template: "products"
	    waitOn: ->
      		@subscribe "products"


	# product view / edit page
  	@route 'product',
    	controller: ShopController
	    path: 'product/:_id/:variant?'
	    template: 'productDetail'
	    waitOn: ->
      		return Meteor.subscribe 'product', @params._id
	    onBeforeAction: ->
		      variant = @params.variant || @params.query.variant
		      setProduct @params._id, variant
		      @next()
		      return
	    data: ->
      		product = selectedProduct()
      		if @ready() and product
	        	unless product.isVisible
	        		unless RealTimeCore.hasPermission(@url)
	        			@render 'unauthorized'
	        	return product
	        if @ready() and !product
	        	@render 'notFound'