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