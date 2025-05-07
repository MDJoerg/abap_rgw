@EndUserText.label: 'Copy REST Action'
define abstract entity ZD_ACF_RGW_CopyAction
{
  @EndUserText.label: 'New REST App'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: App' )
  App : ZACF_RGW_APP;
  @EndUserText.label: 'New REST Action'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: ActionKey' )
  ActionKey : ZACF_RGW_ACTION;
  
}
