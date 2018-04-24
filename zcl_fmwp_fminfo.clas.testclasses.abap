*"* use this source file for your ABAP unit test classes
CLASS ltcl_main DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA: m_cont  TYPE REF TO zcl_abapdi_container,
          m_cut   TYPE REF TO zcl_fmwp_fminfo,
          m_adptr TYPE REF TO zif_fmwp_fmadptr.
    METHODS:
      instanciate FOR TESTING RAISING cx_static_check,
      read FOR TESTING RAISING cx_static_check,
      setup.
ENDCLASS.


CLASS ltcl_main IMPLEMENTATION.
  METHOD setup.
    m_cont = NEW zcl_abapdi_container( ).
    m_cont->register( i_if = 'zif_flsuni' i_cl = 'zcl_flsuni_flwrap' ).
    m_cont->register( i_if = 'zif_fmwp_fmadptr' i_cl = 'zcl_fmwp_fmadptr_imp').
    TRY.
        m_cut = CAST zcl_fmwp_fminfo( m_cont->get_instance( 'zcl_fmwp_fminfo' ) ).
        m_adptr = CAST zif_fmwp_fmadptr( m_cont->get_instance( 'zif_fmwp_fmadptr' ) ).
      CATCH cx_abap_invalid_value.
        "handle exception
        cl_abap_unit_assert=>fail( msg = 'cut generation failed.' ).
    ENDTRY.
  ENDMETHOD.
  METHOD instanciate.
    cl_abap_unit_assert=>assert_bound( act =  m_cut  ).
  ENDMETHOD.
  METHOD read.

  ENDMETHOD.

ENDCLASS.
