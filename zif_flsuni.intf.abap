INTERFACE zif_flsuni
  PUBLIC .
  TYPES: t_dokumentation      TYPE STANDARD TABLE OF funct WITH DEFAULT KEY,
         t_exception_list     TYPE STANDARD TABLE OF rsexc WITH DEFAULT KEY,
         t_export_parameter   TYPE STANDARD TABLE OF rsexp WITH DEFAULT KEY,
         t_import_parameter   TYPE STANDARD TABLE OF rsimp WITH DEFAULT KEY,
         t_changing_parameter TYPE STANDARD TABLE OF rscha WITH DEFAULT KEY,
         t_tables_parameter   TYPE STANDARD TABLE OF rstbl WITH DEFAULT KEY,
         t_enha_exp_parameter TYPE STANDARD TABLE OF rsexc WITH DEFAULT KEY,
         t_enha_imp_parameter TYPE STANDARD TABLE OF rsimp WITH DEFAULT KEY,
         t_enha_cha_parameter TYPE STANDARD TABLE OF rscha WITH DEFAULT KEY,
         t_enha_tbl_parameter TYPE STANDARD TABLE OF rstbl WITH DEFAULT KEY,
         t_enha_dokumentation TYPE STANDARD TABLE OF funct WITH DEFAULT KEY.
  METHODS function_import_doku
    IMPORTING
      funcname                TYPE rs38l-name
      language                TYPE sy-langu DEFAULT sy-langu
      ignore_switches         TYPE char1 DEFAULT abap_false
      with_enhancement        TYPE char1  DEFAULT abap_true
    EXPORTING
      global_flag             TYPE rs38l-global
      remote_call             TYPE rs38l-remote
      update_task             TYPE rs38l-utask
      short_text              TYPE tftit-stext
      freedate                TYPE enlfdir-freedate
      exception_class         TYPE enlfdir-exten3
      remote_basxml_supported TYPE rs38l-basxml_enabled
    CHANGING
      dokumentation           TYPE t_dokumentation OPTIONAL
      exception_list          TYPE t_exception_list OPTIONAL
      export_parameter        TYPE t_export_parameter OPTIONAL
      import_parameter        TYPE t_import_parameter OPTIONAL
      changing_parameter      TYPE t_changing_parameter OPTIONAL
      tables_parameter        TYPE t_tables_parameter OPTIONAL
      enha_exp_parameter      TYPE t_enha_exp_parameter OPTIONAL
      enha_imp_parameter      TYPE t_enha_imp_parameter OPTIONAL
      enha_cha_parameter      TYPE t_enha_cha_parameter OPTIONAL
      enha_tbl_parameter      TYPE t_enha_tbl_parameter OPTIONAL
      enha_dokumentation      TYPE t_enha_dokumentation OPTIONAL
    EXCEPTIONS
      function_not_found
      invalid_name.
ENDINTERFACE.
