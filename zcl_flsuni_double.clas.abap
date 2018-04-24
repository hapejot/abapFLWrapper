CLASS zcl_flsuni_double DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zif_flsuni .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_flsuni_double IMPLEMENTATION.

  METHOD zif_flsuni~function_import_doku.
    IF funcname = 'FUNCTION_IMPORT_DOKU'.
      export_parameter = VALUE #(
                ( parameter = 'GLOBAL_FLAG' dbfield = 'RS38L-GLOBAL    ' )
                ( parameter = 'REMOTE_CALL' dbfield = 'RS38L-REMOTE    ' )
                ( parameter = 'UPDATE_TASK' dbfield = 'RS38L-UTASK     ' )
                ( parameter = 'SHORT_TEXT ' dbfield = 'TFTIT-STEXT     ' )
                ( parameter = 'FREEDATE   ' dbfield = 'ENLFDIR-FREEDATE' ) ).
      changing_parameter = VALUE #(
                ( parameter = 'TST_CHG' dbfield = 'ABAP_BOOL' ) ).
      import_parameter = VALUE #(
                ( parameter = 'FUNCNAME         ' dbfield = 'RS38L-NAME' default ='        '       optional = ' ' typ = '        ' )
                ( parameter = 'LANGUAGE         ' dbfield = '          ' default ='SY-LANGU'       optional = ' ' typ = 'SY-LANGU' )
                ( parameter = 'WITH_ENHANCEMENTS' dbfield = '          ' default ='''X''   '       optional = 'X' typ = 'CHAR1   ' )
                ( parameter = 'IGNORE_SWITCHES  ' dbfield = '          ' default ='SPACE   '       optional = 'X' typ = 'CHAR1   ' ) ).
      tables_parameter = VALUE #(
                ( parameter = 'DOKUMENTATION     ' dbstruct = 'FUNCT'            optional = ' ' )
                ( parameter = 'EXCEPTION_LIST    ' dbstruct = 'RSEXC'            optional = ' ' )
                ( parameter = 'EXPORT_PARAMETER  ' dbstruct = 'RSEXP'            optional = ' ' )
                ( parameter = 'IMPORT_PARAMETER  ' dbstruct = 'RSIMP'            optional = ' ' )
                ( parameter = 'CHANGING_PARAMETER' dbstruct = 'RSCHA'            optional = 'X' ) ).
      exception_list = VALUE #(
                ( exception = 'ERROR_MESSAGE     ' )
                ( exception = 'FUNCTION_NOT_FOUND' )
                ( exception = 'INVALID_NAME      ' ) ).
    ELSE.
      RAISE function_not_found.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
