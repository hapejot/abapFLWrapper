*&---------------------------------------------------------------------*
*& Report zr_fmwp_main
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_fmwp_main.

PARAMETERS p_flib TYPE rs38l_area.

DATA:
        go_main TYPE REF TO zcl_fmwp_main.

INITIALIZATION.
  DATA(m_cnt) = NEW zcl_abapdi_container( ).
  m_cnt->register( i_if = 'zif_flsuni'          i_cl = 'zcl_flsuni_flwrap' ).
  m_cnt->register( i_if = 'zif_flseoq'          i_cl = 'zcl_flseoq_wrap' ).
  m_cnt->register( i_if = 'zif_fmwp_fmadptr'    i_cl = 'zcl_fmwp_fmadptr_imp').
  m_cnt->register( i_if = 'zif_fmwp_gen'        i_cl = 'zcl_fmwp_gen').
  m_cnt->register( i_if = 'zif_fmwp_builder'    i_cl = 'zcl_fmwp_builder' ).

  go_main ?= m_cnt->get_instance( 'zcl_fmwp_main' ).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_flib.
  CALL METHOD go_main->on_value_request_lib
    CHANGING
      p_flib = p_flib.

START-OF-SELECTION.
  CALL METHOD go_main->start_of_selection EXPORTING i_area = p_flib.
