# Template.productDetailEdit.helpers
# 	i18nPlaceholder: () ->
# 		i18nextDep.depend()
# 		i18n_key = "productDetailEdit." + @field
# 		if i18n.t(i18n_key) is i18n_key
# 			console.info "returning empty placeholder,'productDetailEdit:" + i18n_key + "' no i18n key found."
# 			return
# 		else
# 			return i18n.t(i18n_key)

Template.productDetailEdit.rendered = () ->
	#TODO 
	#Agregar autosize a textarea
	$('textarea')
	#autosize($('textarea'))