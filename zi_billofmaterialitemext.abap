*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZI_BILLOFMATERIALITEMEXT
* Description:
*----------------------------------------------------------------------------------------------------------------------

@AbapCatalog.sqlViewAppendName: 'ZIBOMITEMEXT'
@EndUserText.label: 'Extend View I_BillOfMaterialItem'
extend view I_BillOfMaterialItem with ZI_BillOfMaterialItemExt
{
  valid_items.vgknt,
  valid_items.vgpzl,
  valid_items.dvdat
}


----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
