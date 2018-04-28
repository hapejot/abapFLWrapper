CLASS zcl_flseoq_wrap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_flseoq.
    CLASS-METHODS test
      RETURNING
        VALUE(r_rc) TYPE i.
    METHODS seo_class_delete_complete
      IMPORTING
        clskey TYPE seoclskey OPTIONAL
      EXCEPTIONS
        not_existing
        is_interface
        db_error
        no_access
      .
    METHODS seo_class_existence_check
      IMPORTING
        clskey     TYPE seoclskey
      EXPORTING
        not_active TYPE seox_boolean
      EXCEPTIONS
        not_specified
        not_existing
        is_interface
        no_text
        inconsistent
        other.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPE-POOLS:
      seoc,
      seok,
      seop.




ENDCLASS.



CLASS ZCL_FLSEOQ_WRAP IMPLEMENTATION.


  METHOD seo_class_delete_complete.
    CALL FUNCTION 'SEO_CLASS_DELETE_COMPLETE'
      EXPORTING
        clskey       = clskey   " Class
*       genflag      = SPACE    " Generation Flag
*       authority_check      =     " Execute authority check (suppress possible only for GENFLAG
*       suppress_docu_delete =
*       suppress_commit      =     " No DB_COMMIT will be executed
*       suppress_corr        =     " Suppress Corr-Insert and Corr-Check
*       lifecycle_manager    =     " Lifecycle manager
*       lock_handle  =     " Lock Handle
*       suppress_dialog      =     " X = no user interaction
*    CHANGING
*       corrnr       =     " Request/Task
      EXCEPTIONS
        not_existing = 1
        is_interface = 2
        db_error     = 3
        no_access    = 4
        other        = 5
        OTHERS       = 6.
    IF sy-subrc <> 0.
*   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD  seo_class_existence_check.
    CALL FUNCTION 'SEO_CLASS_EXISTENCE_CHECK'
      EXPORTING
        clskey        = clskey
      IMPORTING
        not_active    = not_active
      EXCEPTIONS
        not_specified = 1
        not_existing  = 2
        is_interface  = 3
        no_text       = 4
        inconsistent  = 5
        OTHERS        = 6.
    CASE sy-subrc.
      WHEN 0. " do nothing
      WHEN 1. RAISE not_specified.
      WHEN 2. RAISE not_existing.
      WHEN 3. RAISE is_interface.
      WHEN 4. RAISE no_text.
      WHEN 5. RAISE inconsistent.
      WHEN OTHERS. RAISE other.
    ENDCASE.
  ENDMETHOD.


  METHOD test.
    DATA: l_class TYPE vseoclass.
    l_class = VALUE #(
                clsname     = |{ 'zcl_pjl_test1' CASE = UPPER }|
                state       = seoc_state_implemented
                exposure    = seoc_exposure_public
                langu       = 'EN'
                descript    = 'Generated class'
                clsccincl   = abap_true " new include structure for locals
                unicode     = abap_true
                author      = 'developer'
     ).


    DATA(l_app) = CAST zif_flseoq(  NEW zcl_flseoq_wrap( ) ).
*    CALL METHOD l_app->seo_class_existence_check
*      EXPORTING
*        clskey        = VALUE seoclskey( clsname = l_class-clsname )
*      IMPORTING
*        not_active    = DATA(not_active)
*      EXCEPTIONS
*        not_specified = 1
*        not_existing  = 2
*        is_interface  = 3
*        no_text       = 4
*        inconsistent  = 5
*        other         = 6
*        OTHERS        = 7.
*    IF sy-subrc IS INITIAL.
*      l_app->seo_class_delete_complete(
*        EXPORTING
*          clskey       = VALUE seoclskey( clsname = l_class-clsname )
*        EXCEPTIONS
*          not_existing = 1
*          is_interface = 2
*          db_error     = 3
*          no_access    = 4
*          OTHERS       = 5
*      ).
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
*                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.
*    ENDIF.

    CALL METHOD l_app->seo_class_create_complete
      EXPORTING
        devclass        = '$TMP'
      CHANGING
        class           = l_class
      EXCEPTIONS
        existing        = 1
        is_interface    = 2
        db_error        = 3
        component_error = 4
        no_access       = 5
        other           = 6
        OTHERS          = 7.
    r_rc = sy-subrc.
    MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv4 sy-msgv4.

  ENDMETHOD.


  METHOD zif_flseoq~seo_class_create_complete.
    CALL FUNCTION 'SEO_CLASS_CREATE_COMPLETE'
      EXPORTING
*       corrnr                     =     " Correction Number
        devclass                   = devclass    " Package
        version                    = seoc_version_active    " Active/Inactive
*       genflag                    = SPACE    " Generation Flag
*       authority_check            =
        overwrite                  = abap_true
        suppress_method_generation = abap_false
*       suppress_refactoring_support   =
        method_sources             = method_sources    " Table of Methodsources
*       locals_def                 =     " Sourcetext klassenlokaler Klassen (Definitionsteil)
*       locals_imp                 =     " Sourcetext klassenlokaler Klassen (Implementierungsteil)
*       locals_mac                 =     " ABAP-Source
*       suppress_index_update      =
*       typesrc                    =     " Updated type Source parameter to support more than 9999 char
*       suppress_corr              =
*       suppress_dialog            =
*       lifecycle_manager          =     " Lifecycle manager
*       locals_au                  =     " Sourcecode for local testclasses
*       lock_handle                =     " Lock Handle
*       suppress_unlock            =
*       suppress_commit            =     " No DB_COMMIT will be executed
*       generate_method_impls_wo_frame =     " X -> METHOD_SOURCES have to contain METHOD and ENDMETHOD sta
*    IMPORTING
*       korrnr                     =     " Request/Task
*    TABLES
*       class_descriptions         =     " Short description class/interface
*       component_descriptions     =     " Short description class/interface component
*       subcomponent_descriptions  =     " Class/interface subcomponent short description
      CHANGING
        class                      = class
*       inheritance                =
*       redefinitions              =
        implementings              = implementings
*       impl_details               =
*       attributes                 =
        methods                    = methods
*       events                     =
        types                      = types
*       type_source                =     " This parameter is deprecated. Please use typesrc.
        parameters                 = parameters
*       exceps                     =
*       aliases                    =
*       typepusages                =     " Type group application
*       clsdeferrds                =
*       intdeferrds                =
*       friendships                =
      EXCEPTIONS
        existing                   = 1
        is_interface               = 2
        db_error                   = 3
        component_error            = 4
        no_access                  = 5
        other                      = 6
        OTHERS                     = 7.
    CASE sy-subrc.
      WHEN 0. " do nothing
      WHEN 1. RAISE existing.
      WHEN 2. RAISE is_interface.
      WHEN 3. RAISE db_error.
      WHEN 4. RAISE component_error.
      WHEN 5. RAISE no_access.
      WHEN OTHERS. RAISE other.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
