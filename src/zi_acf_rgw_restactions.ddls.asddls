@EndUserText.label: 'REST Actions Configuration'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_ACF_RGW_RestActions
  as select from zacf_rgwcfr
  association to parent ZI_ACF_RGW_RestAction_S as _RESTAction on $projection.SingletonID = _RESTAction.SingletonID
{
  key app as App,
  key action_key as ActionKey,
  is_active as IsActive,
  description as Description,
  version as Version,
  tags as Tags,
  responsible as Responsible,
  reference_info as ReferenceInfo,
  cc_category as CcCategory,
  action_category as ActionCategory,
  action_type as ActionType,
  action_handler as ActionHandler,
  action_url as ActionUrl,
  action_destination as ActionDestination,
  action_forward_app as ActionForwardApp,
  action_forward_key as ActionForwardKey,
  action_config as ActionConfig,
  request_content_type as RequestContentType,
  request_template_ddic as RequestTemplateDdic,
  request_template_raw as RequestTemplateRaw,
  request_template_json as RequestTemplateJson,
  response_content_type as ResponseContentType,
  response_template_ddic as ResponseTemplateDdic,
  response_template_raw as ResponseTemplateRaw,
  error_default_status as ErrorDefaultStatus,
  error_default_message as ErrorDefaultMessage,
  error_default_reason as ErrorDefaultReason,
  parameter_info as ParameterInfo,
  parameter_1 as Parameter1,
  parameter_2 as Parameter2,
  parameter_3 as Parameter3,
  parameter_4 as Parameter4,
  parameter_5 as Parameter5,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  local_last_changed_at as LocalLastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _RESTAction
  
}
