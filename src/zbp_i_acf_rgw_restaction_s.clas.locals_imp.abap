CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZACF_RGW_CRA'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'RESTActions' table = 'ZACF_RGWCFR' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ACF_RGW_RESTACTION_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR RESTAction
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RESTAction~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR RESTAction
        RESULT result,
      EDIT FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RESTAction~edit.
ENDCLASS.

CLASS LHC_ZI_ACF_RGW_RESTACTION_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: edit_flag            TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled
         ,transport_feature    TYPE abp_behv_field_ctrl VALUE if_abap_behv=>fc-f-mandatory
         ,selecttransport_flag TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ) = abap_false.
      transport_feature = if_abap_behv=>fc-f-unrestricted.
    ENDIF.
    result = VALUE #( FOR key in keys (
               %TKY = key-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_RESTActions = edit_flag
               %FIELD-TransportRequestID = transport_feature
               %ACTION-SelectCustomizingTransptReq = COND #( WHEN key-%IS_DRAFT = if_abap_behv=>mk-off
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE selecttransport_flag ) ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_ACF_RGW_RestAction_S IN LOCAL MODE
      ENTITY RESTAction
        UPDATE FIELDS ( TransportRequestID )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                         ) ).

    READ ENTITIES OF ZI_ACF_RGW_RestAction_S IN LOCAL MODE
      ENTITY RESTAction
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ACF_RGW_RESTACTIONS' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).

    " workaround for the issue with the authorization check
    IS_AUTHORIZED = if_abap_behv=>auth-allowed.

    result-%UPDATE      = is_authorized.
    result-%ACTION-Edit = is_authorized.
    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
  METHOD EDIT.
    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
    IF transport_request IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE ZI_ACF_RGW_RestAction_S
        EXECUTE SelectCustomizingTransptReq FROM VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                                            SingletonID = 1
                                                            %PARAM-transportrequestid = transport_request ) ).
      reported-RESTAction = VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                     SingletonID = 1
                                     %MSG = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_ACF_RGW_RESTACTION_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_ACF_RGW_RESTACTION_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    DATA(transport_from_singleton) = VALUE #( update-RESTAction[ 1 ]-TransportRequestID OPTIONAL ).
    IF transport_from_singleton IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = transport_from_singleton
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_ACF_RGW_RESTACTIONS DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      VALIDATEDATACONSISTENCY FOR VALIDATE ON SAVE
        IMPORTING
          KEYS FOR RESTActions~ValidateDataConsistency,
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR RESTActions
        RESULT result,
      COPYRESTACTIONS FOR MODIFY
        IMPORTING
          KEYS FOR ACTION RESTActions~CopyRESTActions,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR RESTActions
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR RESTActions
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_RESTACTION FOR RESTAction~ValidateTransportRequest
          KEYS_RESTACTIONS FOR RESTActions~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_ACF_RGW_RESTACTIONS IMPLEMENTATION.
  METHOD VALIDATEDATACONSISTENCY.
    READ ENTITIES OF ZI_ACF_RGW_RestAction_S IN LOCAL MODE
      ENTITY RESTActions
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(RESTActions).
    DATA(table) = xco_cp_abap_repository=>object->tabl->database_table->for( 'ZACF_RGWCFR' ).
    DATA: BEGIN OF element_check,
            element  TYPE string,
            check    TYPE REF TO if_xco_dp_check,
          END OF element_check,
          element_checks LIKE TABLE OF element_check WITH EMPTY KEY.
    LOOP AT RESTActions ASSIGNING FIELD-SYMBOL(<RESTActions>).
      element_checks = VALUE #(
        ( element = 'IsActive' check = table->field( 'IS_ACTIVE' )->get_value_check( ia_value = <RESTActions>-IsActive  ) )
      ).
      LOOP AT element_checks INTO element_check.
        INSERT VALUE #( %TKY        = <RESTActions>-%TKY
                        %STATE_AREA = |RESTActions_{ element_check-element }| ) INTO TABLE reported-RESTActions.
        element_check-check->execute( ).
        CHECK element_check-check->passed = xco_cp=>boolean->false.
        INSERT VALUE #( %TKY        = <RESTActions>-%TKY ) INTO TABLE failed-RESTActions.
        LOOP AT element_check-check->messages ASSIGNING FIELD-SYMBOL(<msg>).
          INSERT VALUE #( %TKY = <RESTActions>-%TKY
                          %STATE_AREA = |RESTActions_{ element_check-element }|
                          %PATH-RESTAction-SingletonID = 1
                          %PATH-RESTAction-%IS_DRAFT = <RESTActions>-%IS_DRAFT
                          %msg = mbc_cp_api=>message( )->get_behv_msg_from_value_check( <msg> ) ) INTO TABLE reported-RESTActions ASSIGNING FIELD-SYMBOL(<rep>).
          ASSIGN COMPONENT element_check-element OF STRUCTURE <rep>-%ELEMENT TO FIELD-SYMBOL(<comp>).
          <comp> = if_abap_behv=>mk-on.
        ENDLOOP.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
  METHOD COPYRESTACTIONS.
    DATA new_RESTActions TYPE TABLE FOR CREATE ZI_ACF_RGW_RestAction_S\_RESTActions.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-RESTActions = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_ACF_RGW_RestAction_S IN LOCAL MODE
      ENTITY RESTActions
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_RESTActions)
        FAILED DATA(read_failed).

    IF ref_RESTActions IS NOT INITIAL.
      ASSIGN ref_RESTActions[ 1 ] TO FIELD-SYMBOL(<ref_RESTActions>).
      DATA(key) = keys[ KEY draft %TKY = <ref_RESTActions>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_RESTActions>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_RESTActions>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_RESTActions> EXCEPT
          SingletonID
          CreatedBy
          CreatedAt
          LastChangedBy
          LastChangedAt
          LocalLastChangedAt
        ) ) )
      ) TO new_RESTActions ASSIGNING FIELD-SYMBOL(<new_RESTActions>).
      <new_RESTActions>-%TARGET[ 1 ]-App = to_upper( key-%PARAM-App ).
      <new_RESTActions>-%TARGET[ 1 ]-ActionKey = to_upper( key-%PARAM-ActionKey ).

      MODIFY ENTITIES OF ZI_ACF_RGW_RestAction_S IN LOCAL MODE
        ENTITY RESTAction CREATE BY \_RESTActions
        FIELDS (
                 App
                 ActionKey
                 IsActive
                 Description
                 Version
                 Tags
                 Responsible
                 ReferenceInfo
                 CcCategory
                 ActionCategory
                 ActionType
                 ActionHandler
                 ActionUrl
                 ActionDestination
                 ActionForwardApp
                 ActionForwardKey
                 ActionConfig
                 RequestContentType
                 RequestTemplateDdic
                 RequestTemplateRaw
                 RequestTemplateJson
                 ResponseContentType
                 ResponseTemplateDdic
                 ResponseTemplateRaw
                 ErrorDefaultStatus
                 ErrorDefaultMessage
                 ErrorDefaultReason
                 ParameterInfo
                 Parameter1
                 Parameter2
                 Parameter3
                 Parameter4
                 Parameter5
               ) WITH new_RESTActions
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-RESTActions = mapped_create-RESTActions.
    ENDIF.

    INSERT LINES OF read_failed-RESTActions INTO TABLE failed-RESTActions.

    IF failed-RESTActions IS INITIAL.
      reported-RESTActions = VALUE #( FOR created IN mapped-RESTActions (
                                                 %CID = created-%CID
                                                 %ACTION-CopyRESTActions = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-RESTAction-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-RESTAction-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_ACF_RGW_RESTACTIONS' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyRESTActions = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyRESTActions = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
    ) ).
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    CHECK keys_RESTActions IS NOT INITIAL.
    DATA change TYPE REQUEST FOR CHANGE ZI_ACF_RGW_RestAction_S.
    READ ENTITY IN LOCAL MODE ZI_ACF_RGW_RestAction_S
    FIELDS ( TransportRequestID ) WITH CORRESPONDING #( keys_RESTAction )
    RESULT FINAL(transport_from_singleton).
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-TransportRequestID OPTIONAL )
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZACF_RGWCFR' keys = REF #( keys_RESTActions ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
