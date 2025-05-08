@EndUserText.label: 'REST Action Configuration'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'RESTActions'
  }
}
define root view entity ZI_ACF_RGW_RestActions
  as select from I_Language
    left outer join zacf_rgwcfr on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_ACF_RGW_RESTACTIONS_S as _RESTAction
{
  @UI.facet: [ {
    id: 'ZI_ACF_RGW_RestActionsTP', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'REST Action', 
    position: 1 , 
    targetElement: '_RESTAction'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _RESTAction,
  @UI.hidden: true
  max( zacf_rgwcfr.last_changed_at ) as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as sxco_transport) as TransportRequestID,
  _ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
