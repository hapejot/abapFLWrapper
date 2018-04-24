CLASS zcl_fmwp_gen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_fmwp_gen.
    METHODS constructor
      IMPORTING
        i_fmadptr TYPE REF TO zif_fmwp_fmadptr.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA m_fmadptr TYPE REF TO zif_fmwp_fmadptr.
ENDCLASS.



CLASS zcl_fmwp_gen IMPLEMENTATION.


  METHOD constructor.
    m_fmadptr = i_fmadptr.
  ENDMETHOD.


  METHOD zif_fmwp_gen~class_generate.
    DATA:
            l_name TYPE seocpdname.
    l_name = |{ i_name CASE = UPPER }|.

    DATA(m_fm) = m_fmadptr->read_fm( i_name ).
    DATA(result) = m_fm->get_parameters( ).
    c_class->method_set_def( i_name = l_name ).
    c_class->method_set_imp( i_name = l_name  it_source = VALUE #( ( || ) ( || ) ) ).
  ENDMETHOD.
ENDCLASS.
