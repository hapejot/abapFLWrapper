INTERFACE zif_fmwp_fmadptr
  PUBLIC .
  METHODS:
    read_fm
      IMPORTING
        i_name      TYPE string
      RETURNING
        VALUE(r_fm) TYPE REF TO zcl_fmwp_fminfo.
ENDINTERFACE.
