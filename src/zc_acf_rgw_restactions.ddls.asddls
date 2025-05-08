@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'REST Actions Consumption'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_ACF_RGW_RestActions
  provider contract transactional_query
  as projection on ZI_ACF_RGW_RestActions
{
  key App,
  key ActionKey,
      IsActive,
      Description,
      Version,
      Tags,
      Responsible,
      ReferenceInfo,
      CcCategory,
      ActionCategory,
      ActionType,
      ActionHandler,
      ActionUrl,
      ActionDestination,
      ActionForwardApp,
      ActionForwardKey,
      ActionConfig,
      RequestContentType,
      RequestTemplateDdic,
      RequestTemplateRaw,
      RequestTemplateJson,
      ResponseContentType,
      ResponseTemplateDdic,
      ResponseTemplateRaw,
      ErrorDefaultStatus,
      ErrorDefaultMessage,
      ErrorDefaultReason,
      ParameterInfo,
      Parameter1,
      Parameter2,
      Parameter3,
      Parameter4,
      Parameter5,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      SingletonID,
      /* Associations */
      _RESTAction
}
