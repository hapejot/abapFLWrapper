CLASS zcl_fmwp_main DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_tfdir,
        funcname TYPE tfdir-funcname,
        pname    TYPE tfdir-pname,
        area     TYPE area,
      END OF ts_tfdir.
    METHODS constructor
      IMPORTING
        i_builder TYPE REF TO zif_fmwp_builder.
    METHODS on_value_request_lib
      CHANGING
        p_flib TYPE rs38l_area.
    METHODS start_of_selection
      IMPORTING
        i_area TYPE rs38l_area OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA mo_table TYPE REF TO cl_salv_table.
    DATA m_alv TYPE REF TO cl_gui_alv_grid.
    DATA mt_fieldcat TYPE lvc_t_fcat.
    DATA ms_layout TYPE lvc_s_layo.
    DATA mt_tfdir TYPE STANDARD TABLE OF ts_tfdir.
    DATA mr_builder TYPE REF TO zif_fmwp_builder.

    METHODS: on_single_click FOR EVENT link_click OF cl_salv_events_table
      IMPORTING row column,
      on_double_click FOR EVENT double_click OF cl_salv_events_table
        IMPORTING row column,
      start_of_selection_salv
        IMPORTING
          i_area TYPE string OPTIONAL.


    " event handlers
    METHODS:
      on_grid_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING
            e_row
            e_column
            es_row_no.
    .

ENDCLASS.



CLASS zcl_fmwp_main IMPLEMENTATION.

  METHOD on_value_request_lib.

    CALL FUNCTION 'REPOSITORY_INFO_SYSTEM_F4'
      EXPORTING
        object_type          = 'F'
        object_name          = p_flib
        suppress_selection   = 'X'
      IMPORTING
        object_name_selected = p_flib
      EXCEPTIONS
        cancel               = 00.

  ENDMETHOD.

  METHOD start_of_selection_salv.
    DATA lt_tfdir TYPE STANDARD TABLE OF ts_tfdir.
    DATA(l_pname) = |SAPL{ i_area }|.
    SELECT pname, funcname, substring( pname,4,30 ) AS area FROM tfdir  WHERE pname = @l_pname INTO CORRESPONDING FIELDS OF TABLE @lt_tfdir .

    CALL METHOD cl_salv_table=>factory
      EXPORTING
        list_display = abap_true
      IMPORTING
        r_salv_table = mo_table
      CHANGING
        t_table      = lt_tfdir.



    DATA(lr_columns) = mo_table->get_columns( ).

    DATA(lr_column) = CAST cl_salv_column_table( lr_columns->get_column( 'UTASK' ) ).
    lr_column->set_cell_type( if_salv_c_cell_type=>checkbox ).

    DATA(lr_events) = mo_table->get_event( ).


    SET HANDLER on_double_click FOR lr_events.
    SET HANDLER on_single_click FOR lr_events.

    mo_table->display( ).

  ENDMETHOD.

  METHOD on_single_click.

    MESSAGE column TYPE 'I'.

  ENDMETHOD.

  METHOD on_double_click.

    MESSAGE |Double click { column }| TYPE 'I'.

  ENDMETHOD.

  METHOD start_of_selection.

    DATA(l_pname) = |SAPL{ i_area }|.
    SELECT pname, funcname, substring( pname,4,30 ) AS area FROM tfdir  WHERE pname = @l_pname INTO CORRESPONDING FIELDS OF TABLE @mt_tfdir .
    WRITE / ' ' .
    m_alv = NEW cl_gui_alv_grid(
        i_parent = cl_gui_container=>screen0 ).
    SET HANDLER on_grid_double_click FOR m_alv.
    mt_fieldcat = VALUE #(
          ( fieldname = 'AREA'     rollname = 'AREA' )
          ( fieldname = 'FUNCNAME' rollname = 'RS381_FNAM' )
    ).
    ms_layout = VALUE #( cwidth_opt = abap_true ).
    CALL METHOD m_alv->set_table_for_first_display
      EXPORTING
        is_layout       = ms_layout
      CHANGING
        it_fieldcatalog = mt_fieldcat
        it_outtab       = mt_tfdir.
  ENDMETHOD.

  METHOD on_grid_double_click.

    DATA(ls_row_idx) = e_row-index.
    DATA(ls_method) = mt_tfdir[ ls_row_idx ].
    mr_builder->generate(
      EXPORTING
        i_area     = CONV #( ls_method-area )
        i_funcname = CONV #( ls_method-funcname )
    ). .

  ENDMETHOD.

  METHOD constructor.
    mr_builder = i_builder.
    ASSERT mr_builder IS BOUND.
  ENDMETHOD.

ENDCLASS.
