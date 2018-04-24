*"* use this source file for your ABAP unit test classes
CLASS ltcl_main DEFINITION FINAL FOR TESTING
  INHERITING FROM zcl_fmwp_fmadptr_test
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      setup.
ENDCLASS.


CLASS ltcl_main IMPLEMENTATION.
  METHOD setup.
    m_cont = NEW zcl_abapdi_container( ).
    m_cont->register( i_if = 'zif_flsuni' i_cl = 'zcl_flsuni_double' ).
    m_cont->register( i_if = 'zif_fmwp_fmadptr' i_cl = 'zcl_fmwp_fmadptr_imp').
    TRY.
        m_cut = CAST zif_fmwp_fmadptr( m_cont->get_instance( 'zif_fmwp_fmadptr' ) ).
      CATCH cx_abap_invalid_value.
        "handle exception
        cl_abap_unit_assert=>fail( msg = 'cut generation failed.' ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
