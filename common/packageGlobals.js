// exported, global/window scope
RealTimeCore = {};
RealTimeCore.Schemas = {};
RealTimeCore.Collections = {};
RealTimeCore.Helpers = {};
RealTimeCore.MetaData = {};
RealTimeCore.Locale = {};
RealTimeCore.Events = {};

if (Meteor.isClient) {
  RealTimeCore.Alerts = {};
  RealTimeCore.Subscriptions = {};
}

// convenience
Alerts = RealTimeCore.Alerts;
Schemas = RealTimeCore.Schemas;

// not exported to client (private)
RealTimeRegistry = {};
RealTimeRegistry.Packages = {};
