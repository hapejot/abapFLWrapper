CLASS zcl_fmwp_clsinfo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS method_get_imp
      IMPORTING
        i_fname         TYPE string
      RETURNING
        VALUE(r_result) TYPE rswsourcet.
    METHODS method_set_def
      IMPORTING
        i_name TYPE seocpdname.
    METHODS method_set_imp
      IMPORTING
        i_name    TYPE seocpdname
        it_source TYPE rswsourcet.
    METHODS method_get_def
      IMPORTING
        i_name   TYPE string
      EXPORTING
        r_result TYPE vseomethod
        e_params TYPE seo_parameters
      .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mt_method_sources TYPE STANDARD TABLE OF seo_method_source,
      mt_methods        TYPE seo_methods.

ENDCLASS.



CLASS ZCL_FMWP_CLSINFO IMPLEMENTATION.


  METHOD method_get_def.
    DATA:
            l_name TYPE seocmpname.
    l_name = |{ i_name CASE = UPPER }|.
    r_result = mt_methods[ cmpname = l_name ].
  ENDMETHOD.


  METHOD method_get_imp.
    DATA:
            l_name TYPE seocmpname.
    l_name = |{ i_fname CASE = UPPER }|.

    r_result = mt_method_sources[ cpdname = l_name ]-source.

  ENDMETHOD.


  METHOD method_set_def.

    DATA(lr_meth) = REF #( mt_methods[ cmpname = i_name  ] OPTIONAL ).
    IF lr_meth IS NOT  BOUND.
      APPEND INITIAL LINE TO mt_methods REFERENCE INTO lr_meth.
      lr_meth->cmpname = i_name.
    ENDIF.

  ENDMETHOD.


  METHOD method_set_imp.

    DATA(lr_imp) = REF #( mt_method_sources[ cpdname = i_name ] OPTIONAL ).
    IF lr_imp IS NOT BOUND.
      APPEND INITIAL LINE TO mt_method_sources REFERENCE INTO lr_imp.
      lr_imp->cpdname = i_name.
    ENDIF.
    lr_imp->source = it_source.

  ENDMETHOD.
ENDCLASS.
