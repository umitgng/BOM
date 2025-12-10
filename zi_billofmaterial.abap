*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZI_BILLOFMATERIAL
* Description:
*----------------------------------------------------------------------------------------------------------------------

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multi Level BOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BillOfMaterial
  with parameters
    @Environment.systemField : #SYSTEM_DATE
    p_versdat : datum,
    @Consumption.defaultValue: '01'
    p_variant : stalt
  //  as select from ZI_PRODUCTVERSION( p_datum : $parameters.p_versdat,
  //                                    p_variant : $parameters.p_variant ) as _ProdVersion
  //  //    inner join   ZI_DateBucket                                          as _date              on _date.CalendarDate = $parameters.p_versdat
  //    inner join   I_ProductionVersion                                    as _ProductionVersion on  _ProductionVersion.Material          = _ProdVersion.Material
  //                                                                                              and _ProductionVersion.Plant             = _ProdVersion.Plant
  //                                                                                              and _ProductionVersion.ProductionVersion = _ProdVersion.ProductionVersion
  as select from I_ProductionVersion  as Version
    inner join   I_Mast               as _MaterialBOM   on  _MaterialBOM.Material                   = Version.Material
                                                        and _MaterialBOM.Plant                      = Version.Plant
                                                        and _MaterialBOM.BillOfMaterialVariantUsage = '1'
                                                        and _MaterialBOM.BillOfMaterialVariant      = Version.BillOfMaterialVariant
  // I_BOMSELECTIONEAM
    inner join   zi_stas              as _BOMSelect     on  _BOMSelect.Stlty = 'M'
                                                        and _BOMSelect.Stlnr = _MaterialBOM.BillOfMaterial
                                                        and _BOMSelect.Stlal = _MaterialBOM.BillOfMaterialVariant
    inner join   I_BillOfMaterial     as _BOMHeader     on  _BOMHeader.BillOfMaterialCategory = 'M'
                                                        and _BOMHeader.BillOfMaterial         = _MaterialBOM.BillOfMaterial
                                                        and _BOMHeader.BillOfMaterialVariant  = _MaterialBOM.BillOfMaterialVariant
    inner join   I_BillOfMaterialItem as _BOMItem       on  _BOMItem.BillOfMaterialCategory       = 'M'
                                                        and _BOMItem.BillOfMaterial               = _BOMSelect.Stlnr
                                                        and _BOMItem.BillOfMaterialVariant        = _BOMSelect.Stlal
                                                        and _BOMItem.BillOfMaterialItemNodeNumber = _BOMSelect.Stlkn
    inner join   I_Product            as _Product       on  _Product.Product             = _BOMItem.BillOfMaterialComponent
                                                        and _Product.IsMarkedForDeletion = ''
    inner join   I_ProductPlant       as _MaterialPlant on  _MaterialPlant.Plant   = _MaterialBOM.Plant
                                                        and _MaterialPlant.Product = _MaterialBOM.Material
{
  key _MaterialBOM.BillOfMaterial                                             as BillOfMaterial,
  key Version.Material                                                        as Material,
  key Version.Plant                                                           as Plant,
  key Version.ProductionVersion                                               as ProductionVersion,
      Version.ValidityStartDate                                               as ValidityStartDate,
      Version.ValidityEndDate                                                 as ValidityEndDate,
      @Semantics.quantity.unitOfMeasure: 'BOMHeaderQtyUnit'
      cast( _BOMHeader.BOMHeaderQuantityInBaseUnit as bstmg preserving type ) as BOMHeaderQty,
      _BOMHeader.BOMHeaderBaseUnit                                            as BOMHeaderQtyUnit,
      _BOMItem.BillOfMaterialItemNumber                                       as BillOfMaterialItemNumber,
      _BOMItem.BillOfMaterialComponent                                        as Component,
      _BOMItem.BillOfMaterialItemNodeNumber                                   as BillOfMaterialItemNodeNumber,
      _BOMItem.BOMItemInternalChangeCount                                     as BOMItemInternalChangeCount,
      @Semantics.quantity.unitOfMeasure: 'BOMItemQtyUnit'
      _BOMItem.BillOfMaterialItemQuantity                                     as BOMItemQty,
      _BOMItem.BillOfMaterialItemUnit                                         as BOMItemQtyUnit,
      _BOMItem.ComponentScrapInPercent                                        as ComponentScrapInPercent,
      _BOMItem.ValidityStartDate                                              as BOMValidityStartDate,
      _BOMItem.ValidityEndDate                                                as BOMValidityEndDate,
      _Product.BaseUnit                                                       as BaseUnit,
      _BOMItem.MaterialIsCoProduct                                            as CoProduct,
      //      _BOMItem.IsPhantomItem                                                  as IsPhantomItem,
      case when _MaterialPlant.SpecialProcurementType = '50' then 'X'
      else '' end                                                             as IsPhantomItem,
      _BOMItem.vgknt,
      _BOMItem.vgpzl,
      _BOMItem.dvdat,
      _Product.ProductType

}
where
        Version.BillOfMaterialVariant = $parameters.p_variant
  and(
        _BOMItem.ValidityStartDate    <= $parameters.p_versdat
    and _BOMItem.ValidityEndDate      >= $parameters.p_versdat
  )
  and   _BOMItem.IsDeleted            = ''


----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
