*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZI_STAS_LAST
* Description:
*----------------------------------------------------------------------------------------------------------------------

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SelectionBOM Last'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_stas_last
  as select from stas
{
  key stlty        as Stlty,
  key stlnr        as Stlnr,
  key stlal        as Stlal,
  key stlkn        as Stlkn,
      max( datuv ) as datuv
}
group by
  stlty,
  stlnr,
  stlal,
  stlkn


----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
