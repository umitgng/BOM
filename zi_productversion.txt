*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZI_PRODUCTVERSION
* Description:
*----------------------------------------------------------------------------------------------------------------------

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pick up the minimum production version'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PRODUCTVERSION
  with parameters
    p_datum   : datum,
    @Consumption.defaultValue: '01'
    p_variant : stalt
  as select from I_ProductionVersion
{
  key Material,
  key Plant,
      min(ProductionVersion) as ProductionVersion
}
where
      ProductionVersionIsLocked = ' '
  and ValidityStartDate         <= $parameters.p_datum
  and ValidityEndDate           >= $parameters.p_datum
  and BillOfMaterialVariant     = $parameters.p_variant
group by
  Material,
  Plant


----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
