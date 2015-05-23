

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


# general realtime controller
@ShopController = RouteController.extend
  # onAfterAction: ->
  #   RealTimeCore.MetaData.refresh(@route, @params)
  #   return
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

# we always need to wait on these publications
# Router.waitOn ->
#   @subscribe "shops"
#   @subscribe "Packages"


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
    