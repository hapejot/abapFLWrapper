CLASS zcl_flsuni_flwrap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_flsuni .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_flsuni_flwrap IMPLEMENTATION.
  METHOD zif_flsuni~function_import_doku.
    CALL FUNCTION 'FUNCTION_IMPORT_DOKU'
      EXPORTING
        funcname                = funcname    " Name of the function module
        language                = language " SY-LANGU    " SAP R/3 System, Current Language
        with_enhancements       = with_enhancement "'X'
        ignore_switches         = ignore_switches " SPACE
      IMPORTING
        global_flag             = global_flag    " Global interface
        remote_call             = remote_call                " Function module can be called with
        update_task             = update_task                " Function module luft in the update
        short_text              = short_text                 " Short text for function module
        freedate                = freedate
        exception_class         = exception_class
        remote_basxml_supported = remote_basxml_supported
      TABLES
        dokumentation           = dokumentation          " Short description of parameters
        exception_list          = exception_list         " Table of exceptions
        export_parameter        = export_parameter       " Table of export parameters
        import_parameter        = import_parameter       " Table of import parameters
        changing_parameter      = changing_parameter
        tables_parameter        = tables_parameter       " Table of tables
        enha_exp_parameter      = enha_exp_parameter
        enha_imp_parameter      = enha_imp_parameter
        enha_cha_parameter      = enha_cha_parameter
        enha_tbl_parameter      = enha_tbl_parameter
        enha_dokumentation      = enha_dokumentation
      EXCEPTIONS
        error_message           = 1
        function_not_found      = 2
        invalid_name            = 3
        OTHERS                  = 4.
    CASE sy-subrc.
      WHEN 2.
        RAISE function_not_found.
      WHEN 3.
        RAISE invalid_name.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
