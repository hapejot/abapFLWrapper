*"* use this source file for your ABAP unit test classes
CLASS ltcl_main DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      build_simple_call FOR TESTING RAISING cx_static_check,
      build_call_exporting FOR TESTING RAISING cx_static_check,
      build_call_importing FOR TESTING RAISING cx_static_check,
      build_call_changing FOR TESTING RAISING cx_static_check,
      build_call_tables FOR TESTING RAISING cx_static_check,
      build_call_exception FOR TESTING RAISING cx_static_check,
      build_call_combined FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_main IMPLEMENTATION.

  METHOD build_simple_call.
    DATA(cut) = NEW zcl_fmwp_fcall( ).
    cut->set_name( 'function_name' ).
    CALL METHOD cut->build_source
      IMPORTING
        et_source = DATA(l_src).
    DATA(l_exp_src) = VALUE rswsourcet(
      ( |call function 'FUNCTION_NAME'| )
      ( |exceptions| )
      ( |others = 1| )
      ( |.| ) ).
    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_exp_src act = l_src ).
  ENDMETHOD.

  METHOD build_call_exporting.
    DATA(cut) = NEW zcl_fmwp_fcall( ).
    cut->set_name( 'function_name' ).
    cut->add( i_type = cut->c_exporting i_name = 'param1' i_value = 'value' ).


    CALL METHOD cut->build_source
      IMPORTING
        et_source = DATA(l_src).
    DATA(l_exp_src) = VALUE rswsourcet(
      ( |call function 'FUNCTION_NAME'| )
      ( |exporting| )
      ( |param1 = value| )
      ( |exceptions| )
      ( |others = 1| )
      ( |.| ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_exp_src act = l_src ).
  ENDMETHOD.

  METHOD build_call_importing.
    DATA(cut) = NEW zcl_fmwp_fcall( ).
    cut->set_name( 'function_name' ).
    cut->add( i_type = cut->c_importing i_name = 'param1' i_value = 'value' ).


    CALL METHOD cut->build_source
      IMPORTING
        et_source = DATA(l_src).
    DATA(l_exp_src) = VALUE rswsourcet(
      ( |call function 'FUNCTION_NAME'| )
      ( |importing| )
      ( |param1 = value| )
      ( |exceptions| )
      ( |others = 1| )
      ( |.| ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_exp_src act = l_src ).
  ENDMETHOD.

  METHOD build_call_changing.
    DATA(cut) = NEW zcl_fmwp_fcall( ).
    cut->set_name( 'function_name' ).
    cut->add( i_type = cut->c_changing i_name = 'param1' i_value = 'value' ).


    CALL METHOD cut->build_source
      IMPORTING
        et_source = DATA(l_src).
    DATA(l_exp_src) = VALUE rswsourcet(
      ( |call function 'FUNCTION_NAME'| )
      ( |changing| )
      ( |param1 = value| )
      ( |exceptions| )
      ( |others = 1| )
      ( |.| ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_exp_src act = l_src ).
  ENDMETHOD.

  METHOD build_call_tables.
    DATA(cut) = NEW zcl_fmwp_fcall( ).
    cut->set_name( 'function_name' ).
    cut->add( i_type = cut->c_tables i_name = 'param1' i_value = 'value' ).


    CALL METHOD cut->build_source
      IMPORTING
        et_source = DATA(l_src).
    DATA(l_exp_src) = VALUE rswsourcet(
      ( |call function 'FUNCTION_NAME'| )
      ( |tables| )
      ( |param1 = value| )
      ( |exceptions| )
      ( |others = 1| )
      ( |.| ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_exp_src act = l_src ).
  ENDMETHOD.

  METHOD build_call_exception.
    DATA(cut) = NEW zcl_fmwp_fcall( ).
    cut->set_name( 'function_name' ).
    cut->add( i_type = cut->c_exception i_name = 'param1' ).


    CALL METHOD cut->build_source
      IMPORTING
        et_source = DATA(l_src).
    DATA(l_exp_src) = VALUE rswsourcet(
      ( |call function 'FUNCTION_NAME'| )
      ( |exceptions| )
      ( |param1 = 1| )
      ( |others = 2| )
      ( |.| ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_exp_src act = l_src ).
  ENDMETHOD.

  METHOD build_call_combined.
    DATA(cut) = NEW zcl_fmwp_fcall( ).
    cut->set_name( 'function_name' ).
    cut->add( i_type = cut->c_tables i_name = 'table1' i_value = 'tvalue' ).
    cut->add( i_type = cut->c_importing i_name = 'imp1' i_value = 'i_value' ).
    cut->add( i_type = cut->c_exporting i_name = 'exp1' i_value = 'e_value' ).
    cut->add( i_type = cut->c_changing i_name = 'chg1' i_value = 'c_value' ).
    cut->add( i_type = cut->c_exception i_name = 'param1' ).


    CALL METHOD cut->build_source
      IMPORTING
        et_source = DATA(l_src).
    DATA(l_exp_src) = VALUE rswsourcet(
      ( |call function 'FUNCTION_NAME'| )
      ( |exporting| )
      ( |exp1 = e_value| )
      ( |importing| )
      ( |imp1 = i_value| )
      ( |changing| )
      ( |chg1 = c_value| )
      ( |tables| )
      ( |table1 = tvalue| )
      ( |exceptions| )
      ( |param1 = 1| )
      ( |others = 2| )
      ( |.| ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'src' exp = l_exp_src act = l_src ).
  ENDMETHOD.

ENDCLASS.
