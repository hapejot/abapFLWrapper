INTERFACE zif_flseoq
  PUBLIC .
  METHODS seo_class_create_complete
    IMPORTING
      devclass       TYPE devclass
      method_sources TYPE seo_method_source_table OPTIONAL
    CHANGING
      methods        TYPE seoo_methods_r OPTIONAL
      class          TYPE vseoclass
      parameters     TYPE seos_parameters_r OPTIONAL
      implementings  TYPE seor_implementings_r OPTIONAL
      types          TYPE seoo_types_r OPTIONAL
      impl_details   TYPE seo_redefinitions OPTIONAL
      attributes     TYPE seoo_attributes_r OPTIONAL
    EXCEPTIONS
      existing
      is_interface
      db_error
      component_error
      no_access
      other.

ENDINTERFACE.
