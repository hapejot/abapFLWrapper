CLASS zcl_fmwp_intfinfo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS method_set_def
      IMPORTING
        i_method TYPE vseomethod.
    METHODS constructor
      IMPORTING
        i_clsname TYPE seoclsname.
    METHODS interface_get
      RETURNING
        VALUE(r_result) TYPE vseointerf.
    METHODS methods_get
      RETURNING
        VALUE(r_result) TYPE seoo_methods_r.
    METHODS method_set_param
      IMPORTING
        i_param TYPE vseoparam .
    METHODS method_params_get
      RETURNING
        VALUE(r_result) TYPE seos_parameters_r.
    METHODS type_set_type
      IMPORTING
        i_ls_type TYPE vseotype.
    METHODS type_get_all
      RETURNING
        VALUE(r_result) TYPE seoo_types_r.
    METHODS interface_set
      IMPORTING
        i_interface TYPE vseointerf.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mt_methods   TYPE seoo_methods_r,
      interface    TYPE vseointerf,
      comprisings  TYPE seor_comprisings_r,
      attributes   TYPE seoo_attributes_r,
      events       TYPE seoo_events_r,
      parameters   TYPE seos_parameters_r,
      exceps       TYPE seos_exceptions_r,
      aliases      TYPE seoo_aliases_r,
      typepusages  TYPE seot_typepusages_r,
      clsdeferrds  TYPE seot_clsdeferrds_r,
      intdeferrds  TYPE seot_intdeferrds_r,
      types        TYPE seoo_types_r,
      ms_interface TYPE vseointerf.



ENDCLASS.



CLASS ZCL_FMWP_INTFINFO IMPLEMENTATION.


  METHOD constructor.

    ms_interface = VALUE #(
                        clsname = i_clsname
                        state = seoc_state_implemented
                        exposure = seoc_exposure_public
                        langu = 'EN'
                        descript = 'Generated interface'
                        unicode = 'X'
                    ).

  ENDMETHOD.


  METHOD interface_get.
    r_result = ms_interface.
  ENDMETHOD.


  METHOD interface_set.
    ms_interface = VALUE #( BASE i_interface
                            clsname = |{ i_interface-clsname CASE = UPPER }|
                            state = seoc_state_implemented
                            exposure = seoc_exposure_public
                            unicode = 'X'
                         ).
  ENDMETHOD.


  METHOD methods_get.
    r_result = mt_methods.
  ENDMETHOD.


  METHOD method_params_get.
    r_result = parameters.
  ENDMETHOD.


  METHOD method_set_def.

    DATA(lr_meth) = REF #( mt_methods[ cmpname = i_method-cmpname ] OPTIONAL ).
    IF lr_meth IS NOT BOUND.
      APPEND INITIAL LINE TO mt_methods REFERENCE INTO lr_meth.
    ENDIF.
    lr_meth->* = VALUE #( BASE i_method
                                clsname  = ms_interface-clsname
                        ).

  ENDMETHOD.


  METHOD method_set_param.

    DATA(lr_param) = REF #( parameters[ cmpname = i_param-cmpname sconame = i_param-sconame ] OPTIONAL ).
    IF lr_param IS NOT BOUND.
      APPEND INITIAL LINE TO parameters REFERENCE INTO lr_param.
    ENDIF.
    lr_param->* = VALUE #( BASE i_param
                           clsname = ms_interface-clsname
                         ).

  ENDMETHOD.


  METHOD type_get_all.
    r_result = types.
  ENDMETHOD.


  METHOD type_set_type.

    DATA(lr_type) = REF #( types[ cmpname = i_ls_type-cmpname ] OPTIONAL ).
    IF lr_type IS NOT BOUND.
      APPEND INITIAL LINE TO types REFERENCE INTO lr_type.
    ENDIF.
    lr_type->* = VALUE #( BASE i_ls_type  clsname = ms_interface-clsname ).

  ENDMETHOD.
ENDCLASS.
