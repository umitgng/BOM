*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZP_BOMITEMSEXT
* Description:
*----------------------------------------------------------------------------------------------------------------------

@AbapCatalog.sqlViewAppendName: 'ZPBOMITEMSEXT'
@EndUserText.label: 'Extend View P_BOMItems'
extend view P_BOMItems with ZP_BOMItemsExt

{
  stpo.vgknt,
  stpo.vgpzl,
  stpo.dvdat
}


----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
