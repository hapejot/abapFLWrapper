CLASS zcl_fmwp_clsadptr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          ir_seoq TYPE REF TO zif_flseoq OPTIONAL,
      load
        IMPORTING
          i_name       TYPE string
        RETURNING
          VALUE(r_cls) TYPE REF TO zcl_fmwp_clsinfo,
      class_create
        IMPORTING
          l_cls TYPE REF TO zcl_fmwp_clsinfo.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS c_tmpdevclass TYPE devclass VALUE '$TMP' ##NO_TEXT.
    DATA:
      mr_seoq                   TYPE REF TO zif_flseoq.
    METHODS load_implemented_methods
      IMPORTING
        i_cls  TYPE REF TO zcl_fmwp_clsinfo
        i_impl TYPE vseoimplem.

ENDCLASS.



CLASS zcl_fmwp_clsadptr IMPLEMENTATION.


  METHOD class_create.

    DATA(l_class)           = l_cls->class_get_def( ).
    DATA(lt_methods)        = l_cls->method_get_all_methods( ).
    DATA(lt_params)         = l_cls->method_get_all_params( ).
    DATA(lt_types)          = l_cls->type_get_all( ).
    CALL METHOD mr_seoq->seo_class_create_complete
      EXPORTING
        devclass        = c_tmpdevclass
        method_sources  = l_cls->method_get_all_sources( )
      CHANGING
        class           = l_class
        methods         = lt_methods
        parameters      = lt_params
        types           = lt_types
        implementings   = l_cls->mt_implementings
      EXCEPTIONS
        existing        = 1
        is_interface    = 2
        db_error        = 3
        component_error = 4
        no_access       = 5
        other           = 6
        OTHERS          = 7.

  ENDMETHOD.


  METHOD constructor.
    mr_seoq = ir_seoq.
  ENDMETHOD.


  METHOD load.

    DATA:
      lt_info                   TYPE zcl_flseoy_wrap=>tt_vseoclif,
      aliases                   TYPE seoo_aliases_r,
      attributes                TYPE seoo_attributes_r,
      class                     TYPE vseoclass,
      clsdeferrds               TYPE seot_clsdeferrds_r,
      enhancement_attributes    TYPE enhclasstabattrib,
      enhancement_events        TYPE enhclasstabevent,
      enhancement_implementings TYPE enhclasstabimplementing,
      enhancement_methods       TYPE enhmeth_tabheader,
      enhancement_types         TYPE enhtype_tab,
      events                    TYPE seoo_events_r,
      exceps                    TYPE seos_exceptions_r,
      explore_implementings     TYPE seok_int_typeinfos,
      explore_inheritance       TYPE seok_cls_typeinfos,
      friendships               TYPE seof_friendships_r,
      implementings             TYPE seor_implementings_r,
      impl_details              TYPE seor_redefinitions_r,
      inheritance               TYPE vseoextend,
      intdeferrds               TYPE seot_intdeferrds_r,
      methods                   TYPE seoo_methods_r,
      parameters                TYPE seos_parameters_r,
      redefinitions             TYPE seor_redefinitions_r,
      typepusages               TYPE seot_typepusages_r,
      types                     TYPE seoo_types_r,
      lt_source                 TYPE seop_source.

    DATA(seoy) = NEW zcl_flseoy_wrap( ).
    DATA(seop) = NEW zcl_flseop_wrap( ).
    DATA(seok) = NEW zcl_flseok_wrap( ).

    CALL METHOD seok->seo_class_typeinfo_get
      EXPORTING
        clskey                    = VALUE #( clsname = i_name )
*       version                   = SEOC_VERSION_INACTIVE
*       state                     = '1'
*       with_descriptions         =
*       resolve_eventhandler_typeinfo =
*       with_master_language      =
*       with_enhancements         =
*       read_active_enha          =
*       enha_action               =
*       ignore_switches           = 'X'
      IMPORTING
        aliases                   = aliases
        attributes                = attributes
        class                     = class
        clsdeferrds               = clsdeferrds
        enhancement_attributes    = enhancement_attributes
        enhancement_events        = enhancement_events
        enhancement_implementings = enhancement_implementings
        enhancement_methods       = enhancement_methods
        enhancement_types         = enhancement_types
        events                    = events
        exceps                    = exceps
        explore_implementings     = explore_implementings
        explore_inheritance       = explore_inheritance
        friendships               = friendships
        implementings             = implementings
        impl_details              = impl_details
        inheritance               = inheritance
        intdeferrds               = intdeferrds
        methods                   = methods
        parameters                = parameters
        redefinitions             = redefinitions
        typepusages               = typepusages
        types                     = types.



    IF class IS NOT INITIAL.
      r_cls = NEW zcl_fmwp_clsinfo( ).
      r_cls->ms_class = class.
      r_cls->mt_methods = methods.
      r_cls->mt_parameters = parameters.
      r_cls->mt_types = types.
      r_cls->mt_implementings = implementings.
      r_cls->mt_explore_impl = explore_implementings.
      " types ?
      " sources
      LOOP AT methods INTO DATA(ls_meth).
        CALL FUNCTION 'SEO_METHOD_GET_SOURCE'
          EXPORTING
            mtdkey = VALUE seocpdkey(    clsname = ls_meth-clsname
                                 cpdname = ls_meth-cmpname  )
            state  = 'A'
*           with_enhancements             =     " X = liest auch die Sourcecode Plug-ins
          IMPORTING
            source = lt_source
          EXCEPTIONS
            OTHERS = 6.
        r_cls->method_set_imp( i_method = VALUE #( cpdname = ls_meth-cmpname source = lt_source )  ).
      ENDLOOP.
      LOOP AT explore_implementings INTO DATA(ls_impl).
        LOOP AT ls_impl-methods INTO DATA(ls_impl_meth).
          DATA(cpdname) = |{ ls_impl_meth-clsname }~{ ls_impl_meth-cmpname }|.
          CALL FUNCTION 'SEO_METHOD_GET_SOURCE'
            EXPORTING
              mtdkey = VALUE seocpdkey(    clsname = class-clsname
                                   cpdname = cpdname )
              state  = 'A'
*             with_enhancements             =     " X = liest auch die Sourcecode Plug-ins
            IMPORTING
              source = lt_source
            EXCEPTIONS
              OTHERS = 6.
          r_cls->method_set_imp( i_method = VALUE #( cpdname = cpdname source = lt_source )  ).
        ENDLOOP.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD load_implemented_methods.
    DATA: lt_methods TYPE seoo_methods_r.
    DATA(seok) = NEW zcl_flseok_wrap( ).

    CALL METHOD seok->seo_class_typeinfo_get
      EXPORTING
        clskey  = VALUE #( clsname = i_impl-refclsname )
        version = seoc_version_active
      IMPORTING
        methods = lt_methods.

  ENDMETHOD.

ENDCLASS.
