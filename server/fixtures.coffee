###
# Fixtures is a global server object that it can be reused in packages
# assumes collection data in rt-core/private/data, optionally jsonFile
# use jsonFile when calling from another package, as we can't read the assets from here
###
PackageFixture = ->
  # loadData inserts json into collections on app initilization
  # ex:
  #   jsonFile =  Assets.getText("private/data/Shipping.json")
  #   Fixtures.loadData RealTimeCore.Collections.Shipping, jsonFile
  #
  loadData: (collection, jsonFile) ->
    #check collection, RealTimeCore.Schemas[collection._name]
    check jsonFile, Match.Optional(String)
    if collection.find().count() > 0 then return

   # load fixture data
    RealTimeCore.Events.info "Loading fixture data for "+collection._name
    unless jsonFile
      json = EJSON.parse Assets.getText("private/data/"+collection._name+".json")
    else
      json = EJSON.parse jsonFile

    # loop through and import
    for item, index in json
      collection._collection.insert item, (error, result) ->
        if error
          RealTimeCore.Events.info (error + "Error adding " + index + " items to " + collection._name)
          return false
    if index > 0
      RealTimeCore.Events.info ("Success adding " + index + " items to " + collection._name)
      return
    else
      RealTimeCore.Events.info ("No data imported to " + collection._name)
      return

  #
  # updates package settings, accepts json string
  # example:
  #  Fixtures.loadSettings Assets.getText("settings/Packages.json")
  #
  # This basically "hardcodes" all the settings. You can change them
  # via admin etc for the session, but when the server restarts they'll
  # be restored back to the supplied json
  #
  loadSettings: (json) ->
    check json, String
    validatedJson = EJSON.parse json
    # loop through and import
    for item, index in validatedJson
      exists = RealTimeCore.Collections.Packages.findOne('name': item.name)
      if exists
        result = RealTimeCore.Collections.Packages.upsert(
          { 'name': item.name }, {
            $set:
              'settings': item.settings
              'enabled': item.enabled
          },
          multi: true
          upsert: true
          validate: false)

        RealTimeCore.Events.info "loaded local package data: " + item.name
      return
    return

  #
  # loadI18n for defined shops language source json
  # ex: Fixtures.loadI18n()
  #
  loadI18n: (collection = RealTimeCore.Collections.Translations) ->
    languages = []
    return if collection.find().count() > 0
    # load languages from shops array
    shop = RealTimeCore.Collections.Shops.findOne()
    # find every file in private/data/i18n where <i18n>.json
    RealTimeCore.Events.info "Loading fixture data for " + collection._name
    for language in shop.languages
      json = EJSON.parse Assets.getText("private/data/i18n/" + language.i18n + ".json")

      for item in json
        collection._collection.insert item, (error, result) ->
          if error
            RealTimeCore.Events.info (error + "Error adding " + language.i18n + " items to " + collection._name)
            return
        RealTimeCore.Events.info ("Success adding "+ language.i18n + " to " + collection._name)
    return


# instantiate fixtures
@Fixtures = new PackageFixture

# helper for creating admin users
getDomain = (url) ->
  unless url then url = process.env.ROOT_URL
  domain = url.match(/^https?\:\/\/([^\/:?#]+)(?:[\/:?#]|$)/i)[1]
  return domain

###
# Three methods to create users default (empty db) admin user
###
createDefaultAdminUser = ->
  # options from set env variables
  options = {}
  options.email = process.env.METEOR_EMAIL #set in env if we want to supply email
  options.username = process.env.METEOR_USER
  options.password = process.env.METEOR_AUTH
  domain = getDomain()

  # options from mixing known set ENV production variables
  if process.env.METEOR_EMAIL
    url = process.env.MONGO_URL #pull from default db connect string
    options.username = "Administrator"
    unless options.password then options.password = url.substring(url.indexOf("/") + 2,url.indexOf("@")).split(":")[1]
    RealTimeCore.Events.warn ("\nIMPORTANT! DEFAULT USER INFO (ENV)\n  EMAIL/LOGIN: " + options.email + "\n  PASSWORD: " + options.password + "\n")
  else
    # random options if nothing has been set
    options.username = Meteor.settings?.reaction?.METEOR_USER || "Administrator"
    options.password = Meteor.settings?.reaction?.METEOR_AUTH || Random.secret(8)
    options.email = Meteor.settings?.reaction?.METEOR_EMAIL || Random.id(8).toLowerCase() + "@" + domain
    RealTimeCore.Events.warn ("\nIMPORTANT! DEFAULT USER INFO (RANDOM)\n  EMAIL/LOGIN: " + options.email + "\n  PASSWORD: " + options.password + "\n")

  accountId = Accounts.createUser options
  Roles.addUsersToRoles accountId, ['manage-users','owner','admin']
  shopId = Shops.findOne()._id
  Shops.update shopId,
    $set:
      ownerId: accountId
      email: options.email
    $push:
      members:
        isAdmin: true
        userId: accountId
        permissions: [
            "dashboard/customers",
            "dashboard/products",
            "dashboard/settings",
            "dashboard/settings/account",
            "dashboard/orders"
            ]

###
# load core fixture data
###
loadFixtures = ->
  # Load data from json files
  Fixtures.loadData RealTimeCore.Collections.Products
  Fixtures.loadData RealTimeCore.Collections.Shops
  Fixtures.loadData RealTimeCore.Collections.Tags
  Fixtures.loadI18n RealTimeCore.Collections.Translations

  # Load data from settings/json files
  unless Accounts.loginServiceConfiguration.find().count()
    if Meteor.settings.public?.facebook?.appId
      Accounts.loginServiceConfiguration.insert
        service: "facebook",
        appId: Meteor.settings.public.facebook.appId,
        secret: Meteor.settings.facebook.secret

  # Loop through RealTimeRegistry.Packages object, which now has all packages added by
  # calls to register
  # removes package when removed from meteor, retriggers when package added
  unless RealTimeCore.Collections.Packages.find().count() is Object.keys(RealTimeRegistry.Packages).length
    _.each RealTimeRegistry.Packages, (config, pkgName) ->
      Shops.find().forEach (shop) ->
        RealTimeCore.Events.info "Initializing "+ pkgName
        RealTimeCore.Collections.Packages.upsert {shopId: shop._id, name: pkgName},
          $setOnInsert:
            enabled: !!config.autoEnable
            settings: config.settings
            registry: config.registry
            shopPermissions: config.permissions
            services: config.services

    # remove unused packages
    Shops.find().forEach (shop) ->
      RealTimeCore.Collections.Packages.find().forEach (pkg) ->
        unless _.has(RealTimeRegistry.Packages, pkg.name)
          RealTimeCore.Events.info ("Removing "+ pkg.name)
          RealTimeCore.Collections.Packages.remove {shopId: shop._id, name: pkg.name}

  # create default admin user account
  createDefaultAdminUser() unless Meteor.users.find().count()

###
# Execute start up fixtures
###
Meteor.startup ->
  loadFixtures()
  # data conversion:  if ROOT_URL changes update shop domain
  # for now, we're assuming the first domain is the primary
  # currentDomain = Shops.findOne().domains[0]
  # if currentDomain isnt getDomain()
  #   RealTimeCore.Events.info "Updating domain to " + getDomain()
  #   Shops.update({domains:currentDomain},{$set:{"domains.$":getDomain()}})

  # # data conversion: we now set sessionId or userId, but not both
  # Cart.update {userId: { $exists : true, $ne : null }, sessionId: { $exists : true }}, {$unset: {sessionId: ""}}, {multi: true}

  # notifiy that we're done with initialization
  RealTimeCore.Events.info "RealTime Commerce initialization finished. "
