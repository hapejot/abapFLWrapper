INTERFACE zif_fmwp_gen
  PUBLIC .
  METHODS:
    class_generate
      IMPORTING
        i_name  TYPE string
      CHANGING
        c_class TYPE REF TO zcl_fmwp_clsinfo.
ENDINTERFACE.
