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
          VALUE(r_cls) TYPE REF TO zcl_fmwp_clsinfo
        .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS c_tmpdevclass TYPE devclass VALUE '$TMP' ##NO_TEXT.
    DATA:
         mr_seoq TYPE REF TO zif_flseoq.
    METHODS class_create
      IMPORTING
        l_cls TYPE REF TO zcl_fmwp_clsinfo.
ENDCLASS.



CLASS zcl_fmwp_clsadptr IMPLEMENTATION.


  METHOD class_create.
    DATA(l_class)           = l_cls->class_get_def( ).
    DATA(lt_methods)        = l_cls->method_get_all_methods( ).
    DATA(lt_method_imps)    = l_cls->method_get_all_impls( ).
    DATA(lt_params)         = l_cls->method_get_all_params( ).
    DATA(lt_types)          = l_cls->type_get_all( ).
    CALL METHOD mr_seoq->seo_class_create_complete
      EXPORTING
        devclass        = c_tmpdevclass
        method_sources  = l_cls->method_get_all_sources( )
      CHANGING
        class           = l_class
        methods         = lt_methods
        implementings   = lt_method_imps
        parameters      = lt_params
        types           = lt_types
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
      lt_attr     TYPE zcl_flseoy_wrap=>tt_vseoattrib,
      lt_ids      TYPE zcl_flseoy_wrap=>tt_seoclskey,
      lt_info     TYPE zcl_flseoy_wrap=>tt_vseoclif,
      lt_error    TYPE zcl_flseoy_wrap=>tt_rpygser,
      lt_event    TYPE zcl_flseoy_wrap=>tt_vseoevent,
      lt_except   TYPE zcl_flseoy_wrap=>tt_vseoexcep,
      lt_friends  TYPE zcl_flseoy_wrap=>tt_seofriends,
      lt_instance TYPE zcl_flseoy_wrap=>tt_seoimplrel,
      lt_meta     TYPE zcl_flseoy_wrap=>tt_seometarel,
      lt_method   TYPE zcl_flseoy_wrap=>tt_vseomethod,
      lt_param    TYPE zcl_flseoy_wrap=>tt_vseoparam.

    DATA(seoy) = NEW zcl_flseoy_wrap( ).
    DATA(seop) = NEW zcl_flseop_wrap( ).

    lt_ids = VALUE #( ( clsname = i_name ) ).
    seoy->seo_clif_multi_read(
      CHANGING
        attribute_set           = lt_attr
        clif_ids                = lt_ids
        clif_info_set           = lt_info
        error_set               = lt_error
        event_set               = lt_event
        exception_set           = lt_except
        friends_relation_set    = lt_friends
        instance_relation_set   = lt_instance
        meta_relation_set       = lt_meta
        method_set              = lt_method
        parameter_set           = lt_param
    ).
    IF lines( lt_info ) > 0.
      r_cls = NEW zcl_fmwp_clsinfo( ).
      r_cls->ms_class = CORRESPONDING #( lt_info[ 1 ] ).
      r_cls->mt_methods = lt_method.
      r_cls->mt_parameters = lt_param.
      " types ?
      " sources ?
    ENDIF.

  ENDMETHOD.
ENDCLASS.
