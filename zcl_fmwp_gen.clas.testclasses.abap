*"* use this source file for your ABAP unit test classes
CLASS ltcl_main DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA m_cnt TYPE REF TO zcl_abapdi_container.
    DATA m_cut TYPE REF TO zif_fmwp_gen.
    METHODS:
      generate_class FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_main IMPLEMENTATION.

  METHOD generate_class.

    m_cnt = NEW zcl_abapdi_container( ).
    m_cnt->register( i_if = 'zif_flsuni' i_cl = 'zcl_flsuni_double' ).
    m_cnt->register( i_if = 'zif_fmwp_fmadptr' i_cl = 'zcl_fmwp_fmadptr_imp').

    m_cut = CAST zif_fmwp_gen( m_cnt->get_instance( 'zcl_fmwp_gen' ) ).
    cl_abap_unit_assert=>assert_bound( msg = 'cut' act = m_cut ).
    DATA(l_cls) = NEW zcl_fmwp_clsinfo( ).
    CALL METHOD m_cut->class_generate
      EXPORTING
        i_name  = 'FUNCTION_IMPORT_DOKU'
      CHANGING
        c_class = l_cls.

    " THEN
    DATA(l_meth) = l_cls->method_get_imp( 'function_import_doku' ).
    DATA(l_param) = l_cls->method_get_all_params( ).
    cl_abap_unit_assert=>assert_equals(
        msg = 'msg'
        exp = VALUE vseoparam(
                cmpname = 'FUNCTION_IMPORT_DOKU'
                sconame = 'EXCEPTION_LIST'
                cmptype = '1'
                pardecltyp = 2 " changing weil tabelle
                typtype = '1'
                type = 'TT_RSEXC'
        )
        act = l_param[ cmpname = 'FUNCTION_IMPORT_DOKU' sconame = 'EXCEPTION_LIST' ] ).
    DATA(l_src) = VALUE rswsourcet(
                ( |call function 'FUNCTION_IMPORT_DOKU'| )
                ( |exporting| )
                ( |GLOBAL_FLAG = GLOBAL_FLAG| )
                ( |REMOTE_CALL = REMOTE_CALL| )
                ( |UPDATE_TASK = UPDATE_TASK| )
                ( |SHORT_TEXT = SHORT_TEXT| )
                ( |FREEDATE = FREEDATE| )
                ( |importing| )
                ( |FUNCNAME = FUNCNAME| )
                ( |LANGUAGE = LANGUAGE| )
                ( |WITH_ENHANCEMENTS = WITH_ENHANCEMENTS| )
                ( |IGNORE_SWITCHES = IGNORE_SWITCHES| )
                ( |tables| )
                ( |DOKUMENTATION = DOKUMENTATION| )
                ( |EXCEPTION_LIST = EXCEPTION_LIST| )
                ( |EXPORT_PARAMETER = EXPORT_PARAMETER| )
                ( |IMPORT_PARAMETER = IMPORT_PARAMETER| )
                ( |CHANGING_PARAMETER = CHANGING_PARAMETER| )
                ( |changing| )
                ( |TST_CHG = TST_CHG| )
                ( |exceptions| )
                ( |ERROR_MESSAGE = 1| )
                ( |FUNCTION_NOT_FOUND = 1| )
                ( |INVALID_NAME = 1| )
                ( |others = 2| )
                ( |.| ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_src act = l_meth ).
    CALL METHOD l_cls->method_get_def
      EXPORTING
        i_name       = 'function_import_doku'
      IMPORTING
        e_method_def = DATA(ls_method)
        e_params     = DATA(lt_params).
    cl_abap_unit_assert=>assert_equals(
                msg = 'IGNORE_SWITCHES'
                exp = 0
                act = lt_params[ sconame = 'IGNORE_SWITCHES' ]-pardecltyp ).
    DATA(impl) = l_cls->method_get_all_sources( ).
    DATA(types) = l_cls->type_get_all( ).
    cl_abap_unit_assert=>assert_equals( msg = 'types empty' exp = 5 act = lines( types ) ).
  ENDMETHOD.

ENDCLASS.
