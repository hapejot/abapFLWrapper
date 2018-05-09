CLASS zcl_fmwp_intfgen DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS test
      IMPORTING
        i_name TYPE string.
    METHODS constructor
      IMPORTING
        ir_clsadptr  TYPE REF TO zcl_fmwp_clsadptr
        ir_intfadptr TYPE REF TO zcl_fmwp_intfadptr.
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mr_clsadptr  TYPE REF TO zcl_fmwp_clsadptr,
      mr_intfadptr TYPE REF TO zcl_fmwp_intfadptr.
    METHODS interface_generate
      IMPORTING
        i_name TYPE string.
ENDCLASS.



CLASS zcl_fmwp_intfgen IMPLEMENTATION.


  METHOD constructor.
    mr_clsadptr = ir_clsadptr.
    mr_intfadptr = ir_intfadptr.
  ENDMETHOD.


  METHOD interface_generate.

    DATA: l_clsname TYPE seoclsname.

    DATA(lr_cls) = mr_clsadptr->load( i_name = i_name ).
    l_clsname = i_name.
    l_clsname(3) = 'ZIF'.
    DATA(lr_intf) = NEW zcl_fmwp_intfinfo( i_clsname = l_clsname ).
    DATA(lt_meth) = lr_cls->method_get_all_methods( ).
    DATA(lt_param) = lr_cls->method_get_all_params( ).
    DATA(lt_types) = lr_cls->type_get_all( ).
    LOOP AT lt_meth INTO DATA(ls_meth) WHERE exposure = seoc_exposure_public.
      lr_intf->method_set_def( ls_meth ).
    ENDLOOP.
    LOOP AT lt_param INTO DATA(ls_param).
      lr_intf->method_set_param( ls_param ).
    ENDLOOP.
    LOOP AT lt_types INTO DATA(ls_type).
      lr_intf->type_set_type( ls_type ).
    ENDLOOP.
    mr_intfadptr->create( lr_intf ).

    lr_cls->interface_set( VALUE #( refclsname  = l_clsname
                                    state       = seoc_state_implemented ) ).
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
