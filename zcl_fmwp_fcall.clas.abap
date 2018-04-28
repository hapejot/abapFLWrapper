CLASS zcl_fmwp_fcall DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      c_exporting TYPE c VALUE 'E',
      c_importing TYPE c VALUE 'I',
      c_changing  TYPE c VALUE 'C',
      c_tables    TYPE c VALUE 'T',
      c_exception TYPE c VALUE 'X'.
    METHODS set_name
      IMPORTING
        i_function_name TYPE string.
    METHODS build_source
      EXPORTING
        et_source TYPE rswsourcet.
    METHODS add
      IMPORTING
        i_type  TYPE c
        i_name  TYPE string
        i_value TYPE string OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ts_param,
        ptype TYPE c LENGTH 1,
        name  TYPE string,
        value TYPE string,
      END OF ts_param,
      tt_param TYPE STANDARD TABLE OF ts_param.
    DATA: m_name   TYPE string,
          mt_param TYPE tt_param.
    METHODS append_params
      IMPORTING
        i_section TYPE string
        i_type    TYPE c
      CHANGING
        ct_source TYPE rswsourcet.
ENDCLASS.



CLASS zcl_fmwp_fcall IMPLEMENTATION.


  METHOD add.
    APPEND VALUE #( ptype = i_type name = i_name value = i_value ) TO mt_param.
  ENDMETHOD.


  METHOD append_params.

    DATA lt_lines TYPE STANDARD TABLE OF string.

    lt_lines = VALUE #( FOR <x> IN mt_param WHERE ( ptype = i_type ) ( |{ <x>-name } = { <x>-value }| ) ).

    IF lt_lines IS NOT INITIAL.
      APPEND i_section TO ct_source.
      APPEND LINES OF lt_lines TO ct_source.
    ENDIF.

  ENDMETHOD.


  METHOD build_source.

    et_source = VALUE #( ( |call function '{ m_name }'| ) ).
    CALL METHOD append_params EXPORTING i_section = 'exporting' i_type = c_exporting CHANGING ct_source = et_source.
    CALL METHOD append_params EXPORTING i_section = 'importing' i_type = c_importing CHANGING ct_source = et_source.
    CALL METHOD append_params EXPORTING i_section = 'tables' i_type = c_tables CHANGING ct_source = et_source.
    CALL METHOD append_params EXPORTING i_section = 'changing' i_type = c_changing CHANGING ct_source = et_source.
    APPEND |exceptions| TO et_source.
    LOOP AT mt_param INTO DATA(ls_param) WHERE ptype = c_exception.
      DATA(exc_num) = sy-index.
      APPEND |{ ls_param-name } = { exc_num }| TO et_source.
    ENDLOOP.
    APPEND |others = { exc_num + 1 }| TO et_source.
    APPEND |.| TO et_source.

  ENDMETHOD.


  METHOD set_name.

    m_name = |{ i_function_name CASE = UPPER }|.

  ENDMETHOD.
ENDCLASS.
