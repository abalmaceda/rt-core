###
# Spiderable method to set meta tags for crawl
# accepts current iron-router route
###
RealTimeCore.MetaData =
  settings: {
    title: ''
    meta: []
    ignore: ['viewport','fragment']
  }
  #render and append new metadata
  render:(route) ->
    metaContent =  Blaze.toHTMLWithData(Template.coreHead, Router.current().getName )
    $('head').append(metaContent)
    return  metaContent