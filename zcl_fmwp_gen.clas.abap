CLASS zcl_fmwp_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_fmwp_gen.
    METHODS constructor
      IMPORTING
        i_fmadptr TYPE REF TO zif_fmwp_fmadptr.
    CLASS-METHODS test
      RETURNING
        VALUE(r_rc) TYPE i.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPE-POOLS: seoc, seok , seop.
    DATA m_fmadptr TYPE REF TO zif_fmwp_fmadptr.
    METHODS get_decltype
      IMPORTING
        i_kind           TYPE char0001
      RETURNING
        VALUE(l_pardecl) TYPE seopardecl.

ENDCLASS.



CLASS zcl_fmwp_gen IMPLEMENTATION.


  METHOD constructor.
    m_fmadptr = i_fmadptr.
  ENDMETHOD.


  METHOD zif_fmwp_gen~class_generate.

    DATA:
            l_name TYPE seocpdname.

    l_name = |{ i_name CASE = UPPER }|.

    c_class->method_set_def( VALUE #( cmpname = l_name ) ).

    DATA(m_fm) = m_fmadptr->read_fm( i_name ).
    DATA(result) = m_fm->get_parameters( ).
    DATA(lo_fcall) = NEW zcl_fmwp_fcall( ).
    LOOP AT result INTO DATA(ls_param).
      lo_fcall->add(  i_type = ls_param-kind
                      i_name = |{ ls_param-parameter }|
                      i_value = |{ ls_param-parameter }| ).
      DATA(ls_par) = VALUE vseoparam(
                      cmpname  = l_name
                      sconame  = ls_param-parameter
                      ).
      IF ls_param-kind = 'T'.
        DATA(l_tname) = CONV seocmpname(  |TT_{ ls_param-typ }| ).
        c_class->type_set( VALUE #(
                                    cmpname = l_tname
                                    typesrc = |{ l_tname } type standard table of { ls_param-typ }| ) ).
        ls_par-type =  l_tname.
        ls_par-pardecltyp = get_decltype( ls_param-kind ).
      ELSE.
        IF ls_param-typ IS INITIAL.
          ls_par-type = 'CHAR1'.
        ELSE.
          ls_par-type       = ls_param-typ.
        ENDIF.
        ls_par-typtype    = seoo_typtype_type.
        ls_par-paroptionl = ls_param-optional.
        ls_par-parvalue   = ls_param-default.
        ls_par-pardecltyp =  get_decltype( ls_param-kind ).
        IF ls_param-reference IS INITIAL.
          ls_par-parpasstyp = seos_parpasstyp_byvalue.
        ELSE.
          ls_par-parpasstyp = seos_parpasstyp_byreference.
        ENDIF.
      ENDIF.
      c_class->method_set_param( ls_par ).
    ENDLOOP.
    lo_fcall->set_name( CONV string( l_name ) ).

    lo_fcall->build_source(
      IMPORTING
        et_source = DATA(lt_src)
    ).
    c_class->method_set_imp( VALUE #( cpdname = l_name  source = lt_src ) ).
  ENDMETHOD.

  METHOD test.

    DATA(m_cnt) = NEW zcl_abapdi_container( ).
    m_cnt->register( i_if = 'zif_flsuni' i_cl = 'zcl_flsuni_double' ).
    m_cnt->register( i_if = 'zif_fmwp_fmadptr' i_cl = 'zcl_fmwp_fmadptr_imp').

    DATA(m_cut) = CAST zif_fmwp_gen( m_cnt->get_instance( 'zcl_fmwp_gen' ) ).
    cl_abap_unit_assert=>assert_bound( msg = 'cut' act = m_cut ).
    DATA(l_cls) = NEW zcl_fmwp_clsinfo( ).
    l_cls->class_set_def( VALUE #( clsname = 'zcl_demo_class' ) ).
    CALL METHOD m_cut->class_generate
      EXPORTING
        i_name  = 'FUNCTION_IMPORT_DOKU'
      CHANGING
        c_class = l_cls.

    DATA(l_class) = l_cls->class_get_def( ).
    DATA(lt_methods) = l_cls->method_get_all_methods( ).
    DATA(lt_method_imps) = l_cls->method_get_all_impls( ).
    DATA(lt_sources) = l_cls->method_get_all_sources( ).
    DATA(lt_params) = l_cls->method_get_all_params( ).
    DATA(lt_types) = l_cls->type_get_all( ).
    DATA(l_app) = CAST zif_flseoq( NEW zcl_flseoq_wrap( ) ).
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
    IF sy-subrc IS INITIAL.
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
    ENDIF.

    CALL METHOD l_app->seo_class_create_complete
      EXPORTING
        devclass        = '$TMP'
        method_sources  = lt_sources
      CHANGING
        class           = l_class
        methods         = lt_methods
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
    r_rc = sy-subrc.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv4 sy-msgv4.
    ENDIF.

  ENDMETHOD.

  METHOD get_decltype.
    CASE i_kind.
      WHEN 'I'. l_pardecl = seos_pardecltyp_importing.
      WHEN 'E'. l_pardecl = seos_pardecltyp_exporting.
      WHEN 'C'. l_pardecl = seos_pardecltyp_changing.
      WHEN 'T'. l_pardecl = seos_pardecltyp_changing.
      WHEN 'X'. RETURN.
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
