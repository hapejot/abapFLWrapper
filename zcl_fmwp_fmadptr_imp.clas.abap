CLASS zcl_fmwp_fmadptr_imp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES zif_fmwp_fmadptr.
    CLASS-METHODS integration_test
                    IMPORTING
                      i_fname TYPE string.
    METHODS constructor
      IMPORTING
        io_fmadptr TYPE REF TO zif_flsuni.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
          mo_fmadptr TYPE REF TO zif_flsuni.
ENDCLASS.



CLASS ZCL_FMWP_FMADPTR_IMP IMPLEMENTATION.


  METHOD constructor.
    mo_fmadptr = io_fmadptr.
  ENDMETHOD.


  METHOD integration_test.
    DATA(m_cont) = NEW zcl_abapdi_container( ).
    m_cont->register( i_if = 'zif_flsuni' i_cl = 'zcl_flsuni_flwrap' ).
    m_cont->register( i_if = 'zif_fmwp_fmadptr' i_cl = 'zcl_fmwp_fmadptr_imp').
    DATA(m_cut) = CAST zif_fmwp_fmadptr( m_cont->get_instance( 'zif_fmwp_fmadptr' ) ).

    DATA(m_fm) = m_cut->read_fm( i_fname ).
    DATA(result) = m_fm->get_parameters( ).
    cl_demo_output=>display( result ).
  ENDMETHOD.


  METHOD zif_fmwp_fmadptr~read_fm.
    DATA:
      ls_head      TYPE zcl_fmwp_fminfo=>t_head,
      lt_exporting TYPE zif_flsuni=>t_export_parameter,
      lt_importing TYPE zif_flsuni=>t_import_parameter,
      lt_tables    TYPE zif_flsuni=>t_tables_parameter,
      lt_exception TYPE zif_flsuni=>t_exception_list,
      lt_changing  TYPE zif_flsuni=>t_changing_parameter.
    ls_head-name = |{ i_name CASE = UPPER }|.
    CALL METHOD mo_fmadptr->function_import_doku
      EXPORTING
        funcname           = ls_head-name
*       language           = SY-LANGU
*       ignore_switches    = ABAP_FALSE
*       with_enhancement   = ABAP_TRUE
      IMPORTING
*       global_flag        =
        remote_call        = ls_head-remote_call
*       update_task        =
*       short_text         =
*       freedate           =
*       exception_class    =
*       remote_basxml_supported =
      CHANGING
*       dokumentation      =
        exception_list     = lt_exception
        export_parameter   = lt_exporting
        import_parameter   = lt_importing
        changing_parameter = lt_changing
        tables_parameter   = lt_tables
*       enha_exp_parameter =
*       enha_imp_parameter =
*       enha_cha_parameter =
*       enha_tbl_parameter =
*       enha_dokumentation =
      EXCEPTIONS
        function_not_found = 1
        invalid_name       = 2
        OTHERS             = 3.
    IF sy-subrc IS INITIAL.
      r_fm = NEW zcl_fmwp_fminfo( is_head = ls_head ).
      r_fm->append_parameters( VALUE zcl_fmwp_fminfo=>tt_parameter(
              FOR <xe> IN lt_exporting (
                kind = zcl_fmwp_fminfo=>c_exporting
                parameter = <xe>-parameter
                reference = <xe>-reference
                typ = cond #( when <xe>-dbfield is initial then <xe>-typ else <xe>-dbfield )
              ) ) ).
      r_fm->append_parameters( VALUE zcl_fmwp_fminfo=>tt_parameter(
              FOR <xi> IN lt_importing (
                kind = zcl_fmwp_fminfo=>c_importing
                parameter = <xi>-parameter
                reference = <xi>-reference
                typ = cond #( when <xi>-dbfield is initial then <xi>-typ else <xi>-dbfield )
              ) ) ).
      r_fm->append_parameters( VALUE zcl_fmwp_fminfo=>tt_parameter(
              FOR <xt> IN lt_tables (
                kind = zcl_fmwp_fminfo=>c_tables
                parameter = <xt>-parameter
                typ = cond #( when <xt>-dbstruct is initial then <xt>-typ else <xt>-dbstruct )
              ) ) ).
      r_fm->append_parameters( VALUE zcl_fmwp_fminfo=>tt_parameter(
              FOR <xx> IN lt_exception (
                kind = zcl_fmwp_fminfo=>c_exception
                parameter = <xx>-exception
              ) ) ).
      r_fm->append_parameters( VALUE zcl_fmwp_fminfo=>tt_parameter(
              FOR <xc> IN lt_changing (
                kind = zcl_fmwp_fminfo=>c_changing
                parameter = <xc>-parameter
                reference = <xc>-reference
                typ = cond #( when <xc>-dbfield is initial then <xc>-typ else <xc>-dbfield )
              ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
