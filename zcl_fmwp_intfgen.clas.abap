CLASS zcl_fmwp_intfgen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS test
      IMPORTING
        !i_name TYPE string .
    METHODS constructor
      IMPORTING
        !ir_clsadptr  TYPE REF TO zcl_fmwp_clsadptr
        !ir_intfadptr TYPE REF TO zcl_fmwp_intfadptr .
    METHODS interface_generate
      IMPORTING
        !i_name TYPE string .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mr_clsadptr TYPE REF TO zcl_fmwp_clsadptr .
    DATA mr_intfadptr TYPE REF TO zcl_fmwp_intfadptr .
ENDCLASS.



CLASS zcl_fmwp_intfgen IMPLEMENTATION.


  METHOD constructor.
    mr_clsadptr = ir_clsadptr.
    mr_intfadptr = ir_intfadptr.
  ENDMETHOD.


  METHOD interface_generate.

    DATA: l_clsname TYPE seoclsname.

    DATA(lr_cls) = mr_clsadptr->load( i_name = i_name ).
    DATA(ls_classdef) = lr_cls->class_get_def( ).
    l_clsname = i_name.
    l_clsname(3) = 'ZIF'.
    DATA(lr_intf) = NEW zcl_fmwp_intfinfo( i_clsname = l_clsname ).
    lr_intf->interface_set( i_interface = VALUE vseointerf(
        clsname   = l_clsname
        langu     = ls_classdef-langu
        descript  = 'Interface'  ) ).
    DATA(lt_meth)  = lr_cls->method_get_all_methods( ).
    DATA(lt_param) = lr_cls->method_get_all_params( ).
    DATA(lt_types) = lr_cls->type_get_all( ).
    DATA(lt_src) = lr_cls->method_get_all_sources( ).

    DELETE lt_meth WHERE cmpname = 'CONSTRUCTOR'.
    LOOP AT lt_meth INTO DATA(ls_meth) WHERE exposure = seoc_exposure_public.
      lr_intf->method_set_def( ls_meth ).
*     lr_cls->method_set_def( VALUE #( BASE ls_meth cmpname = |{ l_clsname }~{ ls_meth-cmpname }| ) ).
      lr_cls->method_set_imp( i_method = VALUE #( BASE lt_src[ cpdname = ls_meth-cmpname ]
                                                  cpdname =  |{ l_clsname }~{ ls_meth-cmpname }| ) ).
    ENDLOOP.
    LOOP AT lt_param INTO DATA(ls_param).
      IF line_exists( lt_meth[ cmpname = ls_param-cmpname ] ).
        lr_intf->method_set_param( ls_param ).
*        lr_cls->method_set_param( i_param = VALUE #( BASE ls_param cmpname = |{ l_clsname }~{ ls_param-cmpname }| ) ).
      ENDIF.
    ENDLOOP.
    LOOP AT lt_types INTO DATA(ls_type).
      lr_intf->type_set_type( ls_type ).
    ENDLOOP.
    mr_intfadptr->create( lr_intf ).

    lr_cls->interface_set( i_interface = VALUE #( clsname  = l_clsname
                                                  state       = seoc_state_implemented )
                                                  i_methods = lr_intf->methods_get( )
                                                   ).
    mr_clsadptr->class_create( lr_cls ).

  ENDMETHOD.


  METHOD test.

    DATA(lr_seoq) = NEW zcl_flseoq_wrap( ).
    DATA(lr_clsadptr) = NEW zcl_fmwp_clsadptr( ir_seoq = lr_seoq ).
    DATA(lr_intfadap) = NEW zcl_fmwp_intfadptr( ).
    DATA(lr_intfgen) = NEW zcl_fmwp_intfgen(
        ir_clsadptr  = lr_clsadptr
        ir_intfadptr = lr_intfadap
    ).
    lr_intfgen->interface_generate( i_name = i_name  ).

  ENDMETHOD.
ENDCLASS.
