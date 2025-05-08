@EndUserText.label: 'REST Actions Configuration'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_ACF_RGW_RestActions
  as select from ZACF_RGWCFR
  association to parent ZI_ACF_RGW_RestAction_S as _RESTAction on $projection.SingletonID = _RESTAction.SingletonID
{
  key APP as App,
  key ACTION_KEY as ActionKey,
  IS_ACTIVE as IsActive,
  DESCRIPTION as Description,
  VERSION as Version,
  TAGS as Tags,
  RESPONSIBLE as Responsible,
  REFERENCE_INFO as ReferenceInfo,
  CC_CATEGORY as CcCategory,
  ACTION_CATEGORY as ActionCategory,
  ACTION_TYPE as ActionType,
  ACTION_HANDLER as ActionHandler,
  ACTION_URL as ActionUrl,
  ACTION_DESTINATION as ActionDestination,
  ACTION_FORWARD_APP as ActionForwardApp,
  ACTION_FORWARD_KEY as ActionForwardKey,
  ACTION_CONFIG as ActionConfig,
  REQUEST_CONTENT_TYPE as RequestContentType,
  REQUEST_TEMPLATE_DDIC as RequestTemplateDdic,
  REQUEST_TEMPLATE_RAW as RequestTemplateRaw,
  REQUEST_TEMPLATE_JSON as RequestTemplateJson,
  RESPONSE_CONTENT_TYPE as ResponseContentType,
  RESPONSE_TEMPLATE_DDIC as ResponseTemplateDdic,
  RESPONSE_TEMPLATE_RAW as ResponseTemplateRaw,
  ERROR_DEFAULT_STATUS as ErrorDefaultStatus,
  ERROR_DEFAULT_MESSAGE as ErrorDefaultMessage,
  ERROR_DEFAULT_REASON as ErrorDefaultReason,
  PARAMETER_INFO as ParameterInfo,
  PARAMETER_1 as Parameter1,
  PARAMETER_2 as Parameter2,
  PARAMETER_3 as Parameter3,
  PARAMETER_4 as Parameter4,
  PARAMETER_5 as Parameter5,
  @Semantics.user.createdBy: true
  CREATED_BY as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  CREATED_AT as CreatedAt,
  @Semantics.user.lastChangedBy: true
  LAST_CHANGED_BY as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _RESTAction
  
}
