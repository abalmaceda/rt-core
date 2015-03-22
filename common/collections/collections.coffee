###
# Cart
#
# methods to return cart calculated values
# cartCount, cartSubTotal, cartShipping, cartTaxes, cartTotal
# are calculated by a transformation on the collection
# and are available to use in template as cart.xxx
# in template: {{cart.cartCount}}
# in code: RealTimeCore.Collections.Cart.findOne().cartTotal()
###
RealTimeCore.Collections.Cart = Cart = @Cart = new Mongo.Collection "Cart",
  transform: (cart) ->
    cart.cartCount = ->
      count = 0
      ((count += items.quantity) for items in cart.items) if cart?.items
      return count

    cart.cartShipping = ->
      shipping = cart?.shipping?.shipmentMethod?.rate
      return shipping

    cart.cartSubTotal = ->
      subtotal = 0
      ((subtotal += (items.quantity * items.variants.price)) for items in cart.items) if cart?.items
      subtotal = subtotal.toFixed(2)
      return subtotal

    cart.cartTaxes = ->
      ###
      # TODO: lookup cart taxes, and apply rules here
      ###
      return "0.00"

    cart.cartDiscounts = ->
      ###
      # TODO: lookup discounts, and apply rules here
      ###
      return "0.00"

    cart.cartTotal = ->
      subtotal = 0
      ((subtotal += (items.quantity * items.variants.price)) for items in cart.items) if cart?.items
      shipping = parseFloat cart?.shipping?.shipmentMethod?.rate
      subtotal = (subtotal + shipping) unless isNaN(shipping)
      total = subtotal.toFixed(2)
      return total
    return cart

RealTimeCore.Collections.Cart.attachSchema RealTimeCore.Schemas.Cart

# Customers (not currently actively used)
RealTimeCore.Collections.Customers = Customers = @Customers = new Mongo.Collection "Customers"
RealTimeCore.Collections.Customers.attachSchema RealTimeCore.Schemas.Customer

# Orders
RealTimeCore.Collections.Orders = Orders = @Orders = new Mongo.Collection "Orders"
RealTimeCore.Collections.Orders.attachSchema [RealTimeCore.Schemas.Cart, RealTimeCore.Schemas.OrderItems]

# Packages
RealTimeCore.Collections.Packages = new Mongo.Collection "Packages"
RealTimeCore.Collections.Packages.attachSchema RealTimeCore.Schemas.PackageConfig

# Products
RealTimeCore.Collections.Products = Products = @Products = new Mongo.Collection "Products"
RealTimeCore.Collections.Products.attachSchema RealTimeCore.Schemas.Product

# Shipping
RealTimeCore.Collections.Shipping = new Mongo.Collection "Shipping"
RealTimeCore.Collections.Shipping.attachSchema RealTimeCore.Schemas.Shipping

# Taxes
RealTimeCore.Collections.Taxes = new Mongo.Collection "Taxes"
RealTimeCore.Collections.Taxes.attachSchema RealTimeCore.Schemas.Taxes

# Discounts
RealTimeCore.Collections.Discounts = new Mongo.Collection "Discounts"
RealTimeCore.Collections.Discounts.attachSchema RealTimeCore.Schemas.Discounts

# Shops
RealTimeCore.Collections.Shops = Shops = @Shops = new Mongo.Collection "Shops",
  transform: (shop) ->
    for index, member of shop.members
      member.index = index
      member.user = Meteor.users.findOne member.userId
    return shop

RealTimeCore.Collections.Shops.attachSchema RealTimeCore.Schemas.Shop

# Tags
RealTimeCore.Collections.Tags = Tags = @Tags = new Mongo.Collection "Tags"
RealTimeCore.Collections.Tags.attachSchema RealTimeCore.Schemas.Tag
