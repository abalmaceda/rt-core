Packages = RealTimeCore.Collections.Packages

Meteor.methods
	###
	# 
	# 	Determine user's countryCode and return locale object
	# @example (title)
	# @note message
	# @method signature
	# 	Method tags
	# @option option [type] name description
	# @event name [description]
	# 	Event tags
	# @param name [type] description
	# @property [type] description
	# @return [type] description
	# @see link/reference
	# @throw message
	# @todo message
	###
	getLocale: ->
		@unblock() #prevent waiting for locale
		result = {}
		ip = this.connection.httpHeaders['x-forwarded-for']

		try
			geo = new GeoCoder(geocoderProvider: "freegeoip")
			countryCode = geo.geocode(ip)[0].countryCode.toUpperCase()

		shop = RealTimeCore.Collections.Shops.findOne RealTimeCore.getShopId()

		unless shop
			return result

		# local development always returns 'RD' so we default to 'US'
		# unless shop address has been defined
		if !countryCode or countryCode is 'RD'
			if shop.addressBook
				countryCode = shop.addressBook[0].country
			else
				countryCode = 'US'

		try
		result.locale = shop.locales.countries[countryCode]
		result.currency = {}
		# get currency formats for locale, default if none
		# comma string/list can be used, but for now we're only using one result
		localeCurrency = shop.locales.countries[countryCode].currency.split(',')
		for currency in localeCurrency
			if shop.currencies[currency]
				result.currency = shop.currencies[currency]
				if shop.currency isnt currency
					#TODO Add some alternate configurable services like Open Exchange Rate
					rateUrl = "http://rate-exchange.herokuapp.com/fetchRate?from=" + shop.currency + "&to=" + currency
					exchangeRate = HTTP.get rateUrl
					result.currency.exchangeRate = exchangeRate.data
				return result #returning first match.

		return result