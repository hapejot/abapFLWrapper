CLASS zcl_fmwp_fminfo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CONSTANTS:
      c_importing TYPE c VALUE 'I',
      c_exporting TYPE c VALUE 'E',
      c_changing  TYPE c VALUE 'C',
      c_tables    TYPE c VALUE 'T',
      c_exception TYPE c VALUE 'X'.

    TYPES:
      BEGIN OF t_head,
        name        TYPE rs38l_fnam,
        remote_call TYPE abap_bool,
      END OF t_head,
      BEGIN OF t_parameter,
        kind      TYPE c LENGTH 1, " importing, exporting, changing, exception as seen from calling perspective!
        parameter TYPE parameter,
        dbfield   TYPE likefield,
        types     TYPE rs38l_type,
        reference TYPE rs38l_refe,
        typ       TYPE rs38l_typ,
        class     TYPE rs38l_clas,
        ref_class TYPE rs38l_clas,
        line_of   TYPE rs38l_lino,
        table_of  TYPE rs38l_tabo,
        default   TYPE default__3,
        optional  TYPE abap_bool,
      END OF t_parameter,
      tt_parameter TYPE STANDARD TABLE OF t_parameter WITH KEY parameter.
    METHODS get_head
      RETURNING
        VALUE(r_result) TYPE t_head.
    METHODS constructor
      IMPORTING
        is_head TYPE any OPTIONAL.
    METHODS get_parameters
      RETURNING
        VALUE(r_result) TYPE tt_parameter.
    METHODS append_parameters
      IMPORTING
        it_params TYPE tt_parameter.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      ms_head       TYPE t_head,
      mt_parameters TYPE tt_parameter.
ENDCLASS.



CLASS zcl_fmwp_fminfo IMPLEMENTATION.


  METHOD append_parameters.
    APPEND LINES OF it_params TO mt_parameters.
  ENDMETHOD.


  METHOD constructor.
    ms_head = is_head.
  ENDMETHOD.


  METHOD get_head.
    r_result = ms_head.
  ENDMETHOD.


  METHOD get_parameters.
    r_result = mt_parameters.
  ENDMETHOD.
ENDCLASS.
