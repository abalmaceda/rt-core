Media = RealTimeCore.Collections.Media

Template.productGrid.helpers
  	products: ->
  		return Products.find().fetch()
	    # ###
	    # # take natural sort, sorting by updatedAt
	    # # then resort using positions.position for this tag
	    # # retaining natural sort of untouched items
	    # ###
	    # #sort method
	    # compare = (a, b) ->
	    #   if a.position.position is b.position.position
	    #     x = a.position.updatedAt
	    #     y = b.position.updatedAt
	    #     return (if x > y then -1 else (if x < y then 1 else 0))
	    #   a.position.position - b.position.position

	    # share.tag = @tag?._id ? ""
	    # selector = {}
	    # if @tag
	    #   hashtags = []
	    #   relatedTags = [@tag]
	    #   while relatedTags.length
	    #     newRelatedTags = []
	    #     for relatedTag in relatedTags
	    #       if hashtags.indexOf(relatedTag._id) == -1
	    #         hashtags.push(relatedTag._id)
	    #         if relatedTag.relatedTagIds?.length
	    #           newRelatedTags = _.union(newRelatedTags, Tags.find({_id: {$in: relatedTag.relatedTagIds}}).fetch())
	    #     relatedTags = newRelatedTags
	    #   selector.hashtags = {$in: hashtags}
	    # gridProducts = Products.find(selector).fetch()

	    # for gridProduct, index in gridProducts
	    #   if gridProducts[index].positions? then gridProducts[index].position = (position for position in gridProduct.positions when position.tag is share.tag)[0]
	    #   unless gridProducts[index].position
	    #     gridProducts[index].position =
	    #       position: "-"
	    #       updatedAt: gridProduct.updatedAt

	    # ## helpful debug
	    # # for i,index in gridProducts.sort(compare)
	    # #   console.log index,i.position.position,i._id, i.title,i.position.updatedAt
	    # # return gridProducts
	    # return gridProducts.sort(compare)



Template.gridContent.helpers
	displayPrice: () ->
    	getProductPriceRange(@_id) if @_id