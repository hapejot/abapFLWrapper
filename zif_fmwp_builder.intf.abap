INTERFACE zif_fmwp_builder
  PUBLIC .
  TYPES: lt_funcnames TYPE STANDARD TABLE OF rs38l_fnam.
  METHODS:
    generate
      IMPORTING
        i_area       TYPE string
        it_funcnames TYPE lt_funcnames,
    load
      IMPORTING
        i_area       TYPE string
      RETURNING
        VALUE(l_cls) TYPE REF TO zcl_fmwp_clsinfo.

ENDINTERFACE.
