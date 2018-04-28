INTERFACE zif_fmwp_builder
  PUBLIC .

  METHODS generate
    IMPORTING
      i_area     TYPE string
      i_funcname TYPE string.

ENDINTERFACE.
