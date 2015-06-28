
###
# ---TODO---
#	set language and autorun on change of language
# 	initialize i18n and load data resources for the current language and fallback 'EN'
# 	@message also accepts a range formatted with " - "
#	@param price [String] 
#	@return [String] shop /locale specific formatted price
###
@i18nextDep = new Tracker.Dependency()

Meteor.startup ->
	# set language
	Session.set "language", i18n.detectLanguage()

	# set locale
	Meteor.call 'getLocale', (error,result) ->
		RealTimeCore.Locale = result
		RealTimeCore.Locale.language = Session.get "language"
		return

	# start the autorun after startup, so that "language" session var is already set
	Tracker.autorun () ->
		RealTimeCore.Locale.language = Session.get "language"
		Meteor.subscribe "Translations", RealTimeCore.Locale.language, () ->
			resources =  RealTimeCore.Collections.Translations.find({},{fields:{_id: 0},reactive:false}).fetch()
			# map multiple translations into i18next format
			resources = resources.reduce (x, y) ->
				x[y.i18n]= y.translation
				return x
			, {}

			$.i18n.init {
				lng: RealTimeCore.Locale.language
				fallbackLng: 'en'
				ns: "core"
				resStore: resources
				# debug: true
			},(t)->
				# update labels and messages for autoform,schemas
				for schema, ss of RealTimeCore.Schemas
					ss.labels getLabelsFor(ss, schema)
					ss.messages getMessagesFor(ss, schema)

				#re-init all i18n
				i18nextDep.changed()

				# set document direction class
				if (t('languageDirection') == 'rtl')
					$('html').addClass 'rtl'
				else
					$('html').removeClass 'rtl'

	# reactive translations in all templates
	Template.onRendered () ->
		@autorun () =>
			i18nextDep.depend() #rerun whenever language changes and we re-init $.i18n
			$elements = @$("[data-i18n]")
			$elements.i18n() if typeof $elements.i18n is "function"
			return
		return

	# trigger translations when template are removed
	Template.onDestroyed () ->
		i18nextDep.changed()
		return

###
# ---TODO---
# 	i18n helper
# 	see: http://i18next.com/
# 	pass the translation key as the first argument
# 	and the default message as the second argument
#	@example {{i18n "accountsTemplate.error" "Invalid Email"}}
#	@param i18n_key []
#	@param message 	[]
#	@return [] shop /locale specific formatted price
###
Template.registerHelper "i18n", (i18n_key, message) ->
	i18nextDep.depend()
	unless i18n_key then Meteor.throw("i18n key string required to translate")
	message = new Handlebars.SafeString(message)
	if i18n.t(i18n_key) is i18n_key # return raw message if no translation found
		console.info "no translation found. returning raw message for:" + i18n_key
		return message
	else # returning translated message, i18n key found.
		return i18n.t(i18n_key)

###
# ---TODO---
#	
# 	@message also accepts a range formatted with " - "
#	@param price [String] 
#	@return [String] shop /locale specific formatted price
###
Template.registerHelper "formatPrice", (price) ->
	try
		prices = price.split(' - ')
		for actualPrice in prices
			originalPrice = actualPrice
			#TODO Add user services for conversions
			if RealTimeCore.Locale?.currency?.exchangeRate then actualPrice = actualPrice * RealTimeCore.Locale?.currency?.exchangeRate.Rate
			formattedPrice = accounting.formatMoney actualPrice, RealTimeCore.Locale.currency
			price = price.replace(originalPrice, formattedPrice)
	catch
    	if RealTimeCore.Locale?.currency?.exchangeRate then price = price * RealTimeCore.Locale?.currency?.exchangeRate.Rate
    	price = accounting.formatMoney price, RealTimeCore.Locale?.currency
    return price