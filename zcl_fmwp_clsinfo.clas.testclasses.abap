*"* use this source file for your ABAP unit test classes
CLASS ltcl_main DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      method_impl FOR TESTING RAISING cx_static_check,
      method_def FOR TESTING RAISING cx_static_check,
      method_param FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_main IMPLEMENTATION.

  METHOD method_impl.
    DATA(cut) = NEW zcl_fmwp_clsinfo( ).
    CALL METHOD cut->method_set_imp
      EXPORTING
        i_method = VALUE #(
          cpdname = 'TEST_METHOD_NAME'
          source  = VALUE #( ( |first line| ) ( |Second Line| ) ) ).
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
        i_method = VALUE #(
         cmpname = 'TEST_METHOD_NAME' ).
  ENDMETHOD.

  METHOD method_param.
    DATA(cut) = NEW zcl_fmwp_clsinfo( ).
    CALL METHOD cut->method_set_param
      EXPORTING
        i_param = VALUE #(
          cmpname = 'TEST_METHOD_NAME'
          sconame  = 'PARAM1'
          type  = 'STRING' ).
    DATA(params) = cut->method_get_all_params( ).
    cl_abap_unit_assert=>assert_equals(
            msg = 'TEST_METHOD_NAME'
            exp = VALUE vseoparam(
                    cmpname = 'TEST_METHOD_NAME'
                    sconame = 'PARAM1'
                    cmptype = '1'
                    pardecltyp = '3'
                    typtype = 1 " other
                    type = 'STRING'
            )
            act = params[ cmpname = 'TEST_METHOD_NAME' sconame = 'PARAM1' ] ).

    cut->type_set( VALUE #( cmpname = 'TT_TEST'
                            typesrc = 'tt_test type standard table of string.' ) ).
    DATA(types) = cut->type_get_all( ).
    cl_abap_unit_assert=>assert_equals( msg = 'TYPES' exp = VALUE seo_types(
                                        (
                                            cmpname = 'TT_TEST'
                                            state = seoc_state_implemented
                                            exposure = seoc_exposure_public
                                            typtype = seoo_typtype_others
                                            typesrc = 'tt_test type standard table of string.'
                                        )
                                ) act = types ).
  ENDMETHOD.

ENDCLASS.
