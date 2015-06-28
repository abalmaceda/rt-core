Template.i18nChooser.helpers
	###
    #	Busca los idiomas disponibles
    #	@todo Verificar que es lo retorna exactamente
	#	@param 
	#	@return [] 
	###
	languages: ->
		languages = []
		shop = RealTimeCore.Collections.Shops.findOne()
		if shop?.languages
			for language in shop.languages
				if language.enabled is true
					language.translation = "languages." + language.label.toLowercase
					languages.push language
			return languages
	###
    #	
    #	@todo Verificar que hace esta funcion
	###
	active: () ->
		if Session.equals "language", @.i18n
			return "active"

Template.i18nChooser.events
	###
    #	
    #	@todo Verificar que hace esta funcion
	###
	'click .i18n-language': (event,template)->
		event.preventDefault()
		Session.set('language',@.i18n)