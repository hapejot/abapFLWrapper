CLASS zcl_fmwp_builder DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_fmwp_builder.
    METHODS constructor
      IMPORTING
        ir_gen      TYPE REF TO zif_fmwp_gen
        ir_seoq     TYPE REF TO zif_flseoq
        ir_clsadptr TYPE REF TO zcl_fmwp_clsadptr.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA mr_gen TYPE REF TO zif_fmwp_gen.
    DATA mr_seoq TYPE REF TO zif_flseoq.
    DATA mr_clsadptr TYPE REF TO zcl_fmwp_clsadptr.
ENDCLASS.



CLASS ZCL_FMWP_BUILDER IMPLEMENTATION.


  METHOD constructor.

    mr_gen = ir_gen.
    mr_seoq = ir_seoq.
    mr_clsadptr = ir_clsadptr.

  ENDMETHOD.


  METHOD zif_fmwp_builder~generate.

    DATA(l_cls) = NEW zcl_fmwp_clsinfo( ).
    l_cls->class_set_def( i_name = |zcl_fl{ i_area }_gwrap| ).
    LOOP AT it_funcnames INTO DATA(i_funcname).
      CALL METHOD mr_gen->class_generate
        EXPORTING
          i_name  = CONV #( i_funcname )
        CHANGING
          c_class = l_cls.
    ENDLOOP.

    DATA(l_class)           = l_cls->class_get_def( ).
    DATA(lt_methods)        = l_cls->method_get_all_methods( ).
    DATA(lt_method_imps)    = l_cls->method_get_all_impls( ).
    DATA(lt_sources)        = l_cls->method_get_all_sources( ).
    DATA(lt_params)         = l_cls->method_get_all_params( ).
    DATA(lt_types)          = l_cls->type_get_all( ).

    CALL METHOD mr_seoq->seo_class_create_complete
      EXPORTING
        devclass        = '$TMP'
        method_sources  = lt_sources
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

    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv4 sy-msgv4.
    ENDIF.


  ENDMETHOD.


  METHOD zif_fmwp_builder~load.
    l_cls = mr_clsadptr->load( |ZCL_FL{ i_area CASE = UPPER }_GWRAP| ).
  ENDMETHOD.
ENDCLASS.
