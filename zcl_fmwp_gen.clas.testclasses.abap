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
    DATA(l_meth) = l_cls->method_get_imp( 'function_import_doku' ).
    DATA(l_src) = VALUE rswsourcet( ( || ) ( || ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_src act = l_meth ).
    CALL METHOD l_cls->method_get_def
      EXPORTING
        i_name   = 'function_import_doku'
      IMPORTING
        r_result = DATA(ls_class)
        e_params = DATA(lt_params).
    cl_abap_unit_assert=>assert_equals( msg = 'param1' exp = '' act = lt_params[ 1 ] ).
  ENDMETHOD.

ENDCLASS.
