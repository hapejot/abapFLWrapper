*"* use this source file for your ABAP unit test classes
CLASS ltcl_main DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      method_impl FOR TESTING RAISING cx_static_check,
      method_def FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_main IMPLEMENTATION.

  METHOD method_impl.
    DATA(cut) = NEW zcl_fmwp_clsinfo( ).
    CALL METHOD cut->method_set_imp
      EXPORTING
        i_name    = 'TEST_METHOD_NAME'
        it_source = VALUE #( ( |first line| ) ( |Second Line| ) ).
    CALL METHOD cut->method_get_imp
      EXPORTING
        i_fname  = 'TEST_METHOD_NAME'
      RECEIVING
        r_result = DATA(result).

    cl_abap_unit_assert=>assert_equals( msg = 'result' exp = VALUE rswsourcet( ( |first line| ) ( |Second Line| ) )  act = result ).
  ENDMETHOD.
  METHOD method_def.
    DATA(cut) = NEW zcl_fmwp_clsinfo( ).
    CALL METHOD cut->method_set_def
      EXPORTING
        i_name = 'TEST_METHOD_NAME'.
  ENDMETHOD.
ENDCLASS.
