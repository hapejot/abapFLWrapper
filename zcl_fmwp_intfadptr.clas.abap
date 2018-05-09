CLASS zcl_fmwp_intfadptr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS create
      IMPORTING
        ir_intf TYPE REF TO zcl_fmwp_intfinfo.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.



CLASS zcl_fmwp_intfadptr IMPLEMENTATION.

  METHOD create.

    DATA:
      ls_interface  TYPE vseointerf,
      lt_methods    TYPE seoo_methods_r,
      lt_parameters TYPE seos_parameters_r,
      lt_types      TYPE seo_types.

    ls_interface   = ir_intf->interface_get( ).
    lt_methods     = ir_intf->methods_get( ).
    lt_parameters  = ir_intf->method_params_get( ).
    lt_types       = ir_intf->type_get_all( ).

    CALL FUNCTION 'SEO_INTERFACE_CREATE_COMPLETE'
      EXPORTING
*       corrnr     =     " Correction Number
*       lock_handle                  =     " Lock Handle
*       suppress_unlock              =
*       suppress_commit              =
        devclass   = '$TMP'
*       version    = SEOC_VERSION_INACTIVE    " Active/Inactive
*       genflag    = SPACE    " Generation Flag
*       authority_check              =
        overwrite  = abap_true
*       suppress_refactoring_support =
*       typesrc    =
*       suppress_dialog              =     " Suppress Dialogs
*       suppress_corr                =
*       lifecycle_manager            =     " Lifecycle manager
*  IMPORTING
*       korrnr     =     " Request/Task
*  TABLES
*       class_descriptions           =     " Short description class/interface
*       component_descriptions       =     " Short description class/interface component
*       subcomponent_descriptions    =     " Class/interface subcomponent short description
      CHANGING
        interface  = ls_interface
*       comprisings                  =
*       attributes =
        methods    = lt_methods
*       events     =
        parameters = lt_parameters
*       exceps     =
*       aliases    =
*       typepusages                  =
*       clsdeferrds                  =
*       intdeferrds                  =
        types      = lt_types
*  EXCEPTIONS
*       existing   = 1
*       is_class   = 2
*       db_error   = 3
*       component_error              = 4
*       no_access  = 5
*       other      = 6
*       others     = 7
      .
    IF sy-subrc <> 0.
* MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.




ENDCLASS.
