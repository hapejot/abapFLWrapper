CLASS zcl_flseok_wrap DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS seo_class_typeinfo_get
      IMPORTING
        REFERENCE(clskey)                    TYPE  seoclskey
        VALUE(version)                       TYPE  seoversion DEFAULT seoc_version_inactive
        VALUE(state)                         TYPE  seostate DEFAULT '1'
        VALUE(with_descriptions)             TYPE  seox_boolean DEFAULT seox_true
        VALUE(resolve_eventhandler_typeinfo) TYPE  seox_boolean DEFAULT
          seox_false
        VALUE(with_master_language)          TYPE  seox_boolean DEFAULT
          seox_false
        VALUE(with_enhancements)             TYPE  seox_boolean DEFAULT seox_false
        VALUE(read_active_enha)              TYPE  seox_boolean DEFAULT seox_false
        VALUE(enha_action)                   TYPE  seox_boolean DEFAULT seox_false
        VALUE(ignore_switches)               TYPE  char1 DEFAULT 'X'
      EXPORTING
        !aliases                             TYPE seoo_aliases_r
        !attributes                          TYPE seoo_attributes_r
        !class                               TYPE vseoclass
        !clsdeferrds                         TYPE seot_clsdeferrds_r
        !enhancement_attributes              TYPE enhclasstabattrib
        !enhancement_events                  TYPE enhclasstabevent
        !enhancement_implementings           TYPE enhclasstabimplementing
        !enhancement_methods                 TYPE enhmeth_tabheader
        !enhancement_types                   TYPE enhtype_tab
        !events                              TYPE seoo_events_r
        !exceps                              TYPE seos_exceptions_r
        !explore_implementings               TYPE seok_int_typeinfos
        !explore_inheritance                 TYPE seok_cls_typeinfos
        !friendships                         TYPE seof_friendships_r
        !implementings                       TYPE seor_implementings_r
        !impl_details                        TYPE seor_redefinitions_r
        !inheritance                         TYPE vseoextend
        !intdeferrds                         TYPE seot_intdeferrds_r
        !methods                             TYPE seoo_methods_r
        !parameters                          TYPE seos_parameters_r
        !redefinitions                       TYPE seor_redefinitions_r
        !typepusages                         TYPE seot_typepusages_r
        !types                               TYPE seoo_types_r .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FLSEOK_WRAP IMPLEMENTATION.


  METHOD seo_class_typeinfo_get.
    CALL FUNCTION 'SEO_CLASS_TYPEINFO_GET'
      EXPORTING
        clskey                        = clskey
        version                       = version
        state                         = state
        with_descriptions             = with_descriptions
        resolve_eventhandler_typeinfo = resolve_eventhandler_typeinfo
        with_master_language          = with_master_language
        with_enhancements             = with_enhancements
        read_active_enha              = read_active_enha
        enha_action                   = enha_action
        ignore_switches               = ignore_switches
      IMPORTING
        class                         = class
        attributes                    = attributes
        methods                       = methods
        events                        = events
        types                         = types
        parameters                    = parameters
        exceps                        = exceps
        implementings                 = implementings
        inheritance                   = inheritance
        redefinitions                 = redefinitions
        impl_details                  = impl_details
        friendships                   = friendships
        typepusages                   = typepusages
        clsdeferrds                   = clsdeferrds
        intdeferrds                   = intdeferrds
        explore_inheritance           = explore_inheritance
        explore_implementings         = explore_implementings
        aliases                       = aliases
        enhancement_methods           = enhancement_methods
        enhancement_attributes        = enhancement_attributes
        enhancement_events            = enhancement_events
        enhancement_implementings     = enhancement_implementings
        enhancement_types             = enhancement_types
      EXCEPTIONS
        not_existing                  = 1
        is_interface                  = 2
        model_only                    = 3
        OTHERS                        = 4.
  ENDMETHOD.
ENDCLASS.
