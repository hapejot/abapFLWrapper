INTERFACE zif_fmwp_intfgen
  PUBLIC .


  CLASS-METHODS test
    IMPORTING
      !i_name TYPE string .
  METHODS interface_generate
    IMPORTING
      !i_name TYPE string .
ENDINTERFACE.
