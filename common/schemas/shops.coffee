###
# Shops
###
RealTimeCore.Schemas.ShopMember = new SimpleSchema
  userId:
    type: String
  isAdmin:
    type: Boolean
    optional: true
  permissions:
    type: [String]
    optional: true

RealTimeCore.Schemas.CustomEmailSettings = new SimpleSchema
  username:
    type: String
    optional: true
  password:
    type: String
    optional: true
  host:
    type: String
    optional: true
  port:
    type: Number
    allowedValues: [25, 587, 465, 475, 2525]
    optional: true

RealTimeCore.Schemas.Metafield = new SimpleSchema
  key:
    type: String
    max: 30
    optional: true
  namespace:
    type: String
    max: 20
    optional: true
  scope:
    type: String
    optional: true
  value:
    type: String
    optional: true
  valueType:
    type: String
    optional: true
  description:
    type: String
    optional: true

RealTimeCore.Schemas.Currency = new SimpleSchema
  symbol:
    type: String
    defaultValue: "$"
  format:
    type: String
    defaultValue: "%s%v"
  precision:
    type: String
    defaultValue: "0"
    optional: true
  decimal:
    type: String
    defaultValue: "."
    optional: true
  thousand:
    type: String
    defaultValue: ","
    optional: true

RealTimeCore.Schemas.Country = new SimpleSchema
  name:
    type: String
  code:
    type: String

RealTimeCore.Schemas.currencyEngine = new SimpleSchema
  provider:
    type: String
    defaultValue: "OXR"
  apiKey:
    type: String
    optional: true
    label: "Open Exchange Rates App ID"

RealTimeCore.Schemas.Shop = new SimpleSchema
  _id:
    type: String
    optional: true
  name:
    type: String
    index: 1
  description:
    type: String
    optional: true
  keywords:
    type: String
    optional: true
  addressBook:
    type: [RealTimeCore.Schemas.Address]
  domains:
    type: [String]
    defaultValue: ["localhost"] #see simple schema issue #73
  email:
    type: String
  currency:
    type: String
    defaultValue: "USD"
  currencyEngine:
    type: RealTimeCore.Schemas.currencyEngine
  currencies:
    type: [RealTimeCore.Schemas.Currency]
  public:
    type: String
    optional: true
  timezone:
    type: String
  baseUOM:
    type: String
    optional: true
    defaultValue: "OZ"
    label: "Base Unit of Measure"
  canCheckoutAsGuest:
    type: Boolean
    defaultValue: false
  ownerId:
    type: String
  members:
    type: [RealTimeCore.Schemas.ShopMember]
    index: 1
  metafields:
    type: [RealTimeCore.Schemas.Metafield]
    optional: true
  useCustomEmailSettings:
    type: Boolean
    optional: true
  customEmailSettings:
    type: RealTimeCore.Schemas.CustomEmailSettings
  createdAt:
    type: Date
  updatedAt:
    type: Date
    autoValue : ->
      new Date()  if @isUpdate
    optional: true
