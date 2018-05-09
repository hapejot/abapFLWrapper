CLASS zcl_fmwp_clsinfo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC GLOBAL FRIENDS zcl_fmwp_clsadptr .

  PUBLIC SECTION.
    TYPES: ty_helper_type TYPE c LENGTH 1.
    METHODS:
      method_get_imp            IMPORTING
                                  i_fname         TYPE string
                                RETURNING
                                  VALUE(r_result) TYPE rswsourcet,
      method_set_def            IMPORTING
                                  i_method TYPE vseomethod,
      method_set_param          IMPORTING
                                  i_param TYPE vseoparam,
      method_set_imp            IMPORTING
                                  i_method TYPE seo_method_source,
      type_set                  IMPORTING
                                  i_type TYPE vseotype,
      method_get_def            IMPORTING
                                  i_name       TYPE string
                                EXPORTING
                                  e_method_def TYPE vseomethod
                                  e_params     TYPE seo_parameters,
      method_get_all_methods    RETURNING
                                  VALUE(r_result) TYPE seo_methods,

      method_get_all_params     RETURNING
                                  VALUE(r_result) TYPE seo_parameters,
      class_get_def             RETURNING
                                  VALUE(r_result) TYPE vseoclass,
      class_set_def             IMPORTING
                                  i_cls TYPE vseoclass,
      method_get_all_sources    RETURNING
                                  VALUE(r_result) TYPE seo_method_source_table,
      method_get_all_impls      RETURNING
                                  VALUE(r_result) TYPE seo_implementings,
      type_get_all              RETURNING
                                  VALUE(r_result) TYPE seo_types,
      interface_set
        IMPORTING
          i_implementing TYPE vseoimplem.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      ms_class          TYPE vseoclass,
      mt_method_sources TYPE seo_method_source_table,
      mt_methods        TYPE seo_methods, " vseomethod
      mt_method_impls   TYPE seo_implementings,
      mt_parameters     TYPE seo_parameters,
      mt_types          TYPE seo_types,
      mt_implementings  TYPE seor_implementings_r,
      mt_explore_impl   TYPE seok_int_typeinfos,
      m_clsname         TYPE seoclsname.





ENDCLASS.



CLASS zcl_fmwp_clsinfo IMPLEMENTATION.


  METHOD class_get_def.

    m_clsname = ms_class-clsname.
    r_result = ms_class.

  ENDMETHOD.


  METHOD class_set_def.

    ms_class = VALUE #( BASE i_cls
                clsname     = |{ i_cls-clsname CASE = UPPER }|
                state       = seoc_state_implemented
                exposure    = seoc_exposure_public
                clsccincl   = abap_true " new include structure for locals
                unicode     = abap_true
                author      = sy-uname ).

  ENDMETHOD.


  METHOD interface_set.

    APPEND VALUE #( BASE i_implementing
                    clsname     = ms_class-clsname
                  ) TO mt_implementings.

  ENDMETHOD.


  METHOD method_get_all_impls.

  ENDMETHOD.


  METHOD method_get_all_methods.

    LOOP AT mt_methods REFERENCE INTO DATA(lr_meth).
      lr_meth->clsname = m_clsname.
    ENDLOOP.
    r_result = mt_methods.

  ENDMETHOD.


  METHOD method_get_all_params.

    LOOP AT mt_parameters REFERENCE INTO DATA(lr_param).
      lr_param->clsname = m_clsname.
    ENDLOOP.
    r_result = mt_parameters.

  ENDMETHOD.


  METHOD method_get_all_sources.

    r_result = mt_method_sources.

  ENDMETHOD.


  METHOD method_get_def.

    DATA(l_name) = CONV seocmpname( |{ i_name CASE = UPPER }| ).
    e_method_def = mt_methods[ cmpname = l_name ].
    e_params = VALUE #( FOR <x> IN mt_parameters WHERE ( cmpname = l_name ) ( <x> ) ).

  ENDMETHOD.


  METHOD method_get_imp.

    DATA(l_name) = CONV seocmpname( |{ i_fname CASE = UPPER }| ).
    r_result = mt_method_sources[ cpdname = l_name ]-source.

  ENDMETHOD.


  METHOD method_set_def.

    DATA(lr_meth) = REF #( mt_methods[ cmpname = i_method-cmpname  ] OPTIONAL ).
    IF lr_meth IS NOT  BOUND.
      APPEND INITIAL LINE TO mt_methods REFERENCE INTO lr_meth.
    ENDIF.
    lr_meth->* = VALUE #( BASE i_method
            clsname     = ms_class-clsname
            state       = seoc_state_implemented
            exposure    = seoc_exposure_public
            mtddecltyp  = seoo_mtddecltyp_method
            ).

  ENDMETHOD.


  METHOD method_set_imp.

    DATA(lr_imp) = REF #( mt_method_sources[ cpdname = i_method-cpdname ] OPTIONAL ).
    IF lr_imp IS NOT BOUND.
      APPEND INITIAL LINE TO mt_method_sources REFERENCE INTO lr_imp.
    ENDIF.
    lr_imp->* = i_method.

  ENDMETHOD.


  METHOD method_set_param.

    DATA(l_pardecl) = seos_pardecltyp_returning.
*    CASE i_partype.
*      WHEN 'I'. l_pardecl = seos_pardecltyp_importing.
*      WHEN 'E'. l_pardecl = seos_pardecltyp_exporting.
*      WHEN 'C'. l_pardecl = seos_pardecltyp_changing.
*      WHEN 'T'. l_pardecl = seos_pardecltyp_changing.
*      WHEN 'X'. RETURN.
*    ENDCASE.

    DATA(lr_param) = REF #( mt_parameters[ cmpname = i_param-cmpname sconame = i_param-sconame ] OPTIONAL ).
    IF lr_param IS NOT BOUND.
      APPEND INITIAL LINE TO mt_parameters REFERENCE INTO lr_param.
    ENDIF.
    lr_param->* = VALUE #( BASE i_param
                            clsname = ms_class-clsname
                            cmptype = seoo_cmptype_method
                            ).

  ENDMETHOD.


  METHOD type_get_all.

    LOOP AT mt_types REFERENCE INTO DATA(lr_type).
      lr_type->clsname = m_clsname.
    ENDLOOP.
    r_result = mt_types.

  ENDMETHOD.


  METHOD type_set.

    DATA(lr_type) = REF #( mt_types[ cmpname = i_type-cmpname ] OPTIONAL ).
    IF lr_type IS NOT BOUND.
      APPEND INITIAL LINE TO mt_types REFERENCE INTO lr_type.
    ENDIF.
    lr_type->* = VALUE #( BASE i_type
                            clsname = ms_class-clsname
                            state    = seoc_state_implemented
                            exposure = seoc_exposure_public
                            typtype  = seoo_typtype_others
                        ).

  ENDMETHOD.
ENDCLASS.
