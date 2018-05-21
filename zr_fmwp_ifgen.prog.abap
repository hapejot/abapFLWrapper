*&---------------------------------------------------------------------*
*& Report zr_fmwp_ifgen
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_fmwp_ifgen.

PARAMETERS p_class TYPE string.



START-OF-SELECTION.
  DATA(m_cnt) = NEW zcl_abapdi_container( ).
  m_cnt->register( i_if = 'zif_flsuni'          i_cl = 'zcl_flsuni_flwrap' ).
  m_cnt->register( i_if = 'zif_flseoq'          i_cl = 'zcl_flseoq_wrap' ).
  m_cnt->register( i_if = 'zif_fmwp_fmadptr'    i_cl = 'zcl_fmwp_fmadptr_imp' ).
  m_cnt->register( i_if = 'zif_fmwp_gen'        i_cl = 'zcl_fmwp_gen' ).
  m_cnt->register( i_if = 'zif_fmwp_intfadptr'  i_cl = 'zcl_fmwp_intfadptr' ).
  m_cnt->register( i_if = 'zif_fmwp_intfgen'    i_cl = 'zcl_fmwp_intfgen' ).
  m_cnt->register( i_if = 'zif_fmwp_builder'    i_cl = 'zcl_fmwp_builder' ).


  DATA(lr_gen) = CAST zif_fmwp_intfgen( m_cnt->get_instance( i_classname = 'zif_fmwp_intfgen' ) ).
  lr_gen->interface_generate( i_name = p_class ).
  WRITE: / 'interface for class', p_class, 'generated.'.
