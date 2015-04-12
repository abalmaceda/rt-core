

###
#  Global Route Configuration
#  Extend/override in reaction/client/routing.coffee
###
Router.configure
  notFoundTemplate: "notFound"
  loadingTemplate: "loading"
  onBeforeAction: ->
    @render "loading"
  #   Alerts.removeSeen()
    @next()
    return


# general reaction controller
@ShopController = RouteController.extend
  # onAfterAction: ->
  #   ReactionCore.MetaData.refresh(@route, @params)
  #   return
  layoutTemplate: "coreLayout"
  # yieldTemplates:
  #   layoutHeader:
  #     to: "layoutHeader"
  #   layoutFooter:
  #     to: "layoutFooter"
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
    