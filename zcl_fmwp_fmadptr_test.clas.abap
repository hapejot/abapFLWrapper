CLASS zcl_fmwp_fmadptr_test DEFINITION FOR TESTING
  PUBLIC
  DURATION SHORT
  ABSTRACT
  RISK LEVEL HARMLESS
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      instanciate FOR TESTING RAISING cx_static_check,
      read FOR TESTING RAISING cx_static_check.
  PROTECTED SECTION.
    DATA: m_cont TYPE REF TO zcl_abapdi_container,
          m_cut  TYPE REF TO zif_fmwp_fmadptr.

  PRIVATE SECTION.



ENDCLASS.



CLASS ZCL_FMWP_FMADPTR_TEST IMPLEMENTATION.


  METHOD instanciate.
    cl_abap_unit_assert=>assert_bound( act =  m_cut  ).
  ENDMETHOD.


  METHOD read.
    " data(fname) = |FUNCTION_IMPORT_DOKU|.
    DATA(m_fm) = CAST zcl_fmwp_fminfo( m_cut->read_fm( 'Function_Import_Doku' ) ).
    cl_abap_unit_assert=>assert_bound( msg = 'fm not bound' act = m_fm ).
    cl_abap_unit_assert=>assert_equals( msg = 'different func.name' act = m_fm->get_head( )-name exp = 'FUNCTION_IMPORT_DOKU' ).
    DATA(result) = m_fm->get_parameters( ).
    DATA(param1) = result[ parameter = 'REMOTE_CALL' ].
    cl_abap_unit_assert=>assert_equals( msg = 'Remote Parameter' exp = 'E' act = param1-kind ).
    cl_abap_unit_assert=>assert_equals( msg = 'importing'        exp = 'I' act = result[ parameter = 'WITH_ENHANCEMENTS' ]-kind ).
    cl_abap_unit_assert=>assert_equals( msg = 'table'            exp = 'T' act = result[ parameter = 'CHANGING_PARAMETER' ]-kind ).
    cl_abap_unit_assert=>assert_equals( msg = 'exception'        exp = 'X' act = result[ parameter = 'FUNCTION_NOT_FOUND' ]-kind ).
    cl_abap_unit_assert=>assert_equals( msg = 'changing'         exp = 'C' act = result[ parameter = 'TST_CHG' ]-kind ).
  ENDMETHOD.
ENDCLASS.
