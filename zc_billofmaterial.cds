*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZC_BILLOFMATERIAL
* Description:
*----------------------------------------------------------------------------------------------------------------------

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multi Level BOM'
@Metadata.ignorePropagatedAnnotations: true
@Analytics.settings.maxProcessingEffort:#UNLIMITED
@ObjectModel: { usageType:{ serviceQuality: #X,
                            sizeCategory: #XXL,
                            dataClass: #TRANSACTIONAL},
                modelingPattern: #ANALYTICAL_QUERY,
                supportedCapabilities: [#ANALYTICAL_QUERY ] }

@VDM.viewType: #CONSUMPTION
@Analytics.query: true
define view entity ZC_BILLOFMATERIAL
  with parameters
    @Environment.systemField : #SYSTEM_DATE
    p_date    : datum,
    //    @AnalyticsDetails.variable.multipleSelections: true
    p_filter   : abap.char( 1200 ), --stck_filter_string,
    p_werks   : werks_d,
    @Consumption.defaultValue: '01'
    p_variant : stalt
  as select from ZI_BILLOFMATERIALLIST( p_date    : $parameters.p_date,
                                        p_filter  : $parameters.p_filter,
                                        p_werks   : $parameters.p_werks,
                                        p_variant : $parameters.p_variant ) as BOM_Components

{
         @EndUserText.label: 'BillOfMaterial'
         @AnalyticsDetails.query.display: #KEY
         @AnalyticsDetails.query.axis: #FREE
  key    BillOfMaterial,
         @EndUserText.label: 'Material'
         @AnalyticsDetails.query.display: #KEY
         @AnalyticsDetails.query.axis: #FREE
  key    Material,
         @AnalyticsDetails.query.display: #KEY
         @EndUserText.label: 'Plant'
         @AnalyticsDetails.query.axis: #FREE
  key    Plant,
         @EndUserText.label: 'ProductionVersion'
         @AnalyticsDetails.query.axis: #FREE
         ProductionVersion,
         @EndUserText.label: 'ValidityStartDate'
         @AnalyticsDetails.query.axis: #FREE
         ValidityStartDate,
         @EndUserText.label: 'ValidityEndDate'
         @AnalyticsDetails.query.axis: #FREE
         ValidityEndDate,
         @EndUserText.label: 'BOMHeaderQty'
         @AnalyticsDetails.query.axis: #FREE
         @Semantics.quantity.unitOfMeasure: 'BOMHeaderQtyUnit'
         BOMHeaderQty,
         @EndUserText.label: 'BOMHeaderQtyUnit'
         @AnalyticsDetails.query.axis: #FREE
         BOMHeaderQtyUnit,
         @EndUserText.label: 'BOMLevel'
         @AnalyticsDetails.query.axis: #FREE
         BOMLevel,
//         @EndUserText.label: 'MainProduct'
//         @AnalyticsDetails.query.axis: #FREE
//         MainProduct,
         @EndUserText.label: 'Parent'
         @AnalyticsDetails.query.axis: #FREE
         Parent,
         @EndUserText.label: 'Component'
         @AnalyticsDetails.query.axis: #FREE
         Component,
         @EndUserText.label: 'BOMItemQty'
         @AnalyticsDetails.query.axis: #FREE
         @Semantics.quantity.unitOfMeasure: 'BOMItemQtyUnit'
         BOMItemQty,
         @EndUserText.label: 'BOMItemQtyUnit'
         @AnalyticsDetails.query.axis: #FREE
         BOMItemQtyUnit,
         @EndUserText.label: 'ComponentScrapInPercent'
         @AnalyticsDetails.query.axis: #FREE
         ComponentScrapInPercent,
         @EndUserText.label: 'BOMValidityStartDate'
         @AnalyticsDetails.query.axis: #FREE
         BOMValidityStartDate,
         @EndUserText.label: 'BOMValidityEndDate'
         @AnalyticsDetails.query.axis: #FREE
         BOMValidityEndDate,
         @EndUserText.label: 'BaseUnit'
         @AnalyticsDetails.query.axis: #FREE
         BaseUnit,
         @EndUserText.label: 'BaseUnit'
         @AnalyticsDetails.query.axis: #FREE
         CoProduct,
         @EndUserText.label: 'IsPhantomItem'
         @AnalyticsDetails.query.axis: #FREE
         IsPhantomItem,
         @EndUserText.label: 'node'
         @AnalyticsDetails.query.axis: #FREE
         node,
         @EndUserText.label: 'hierarchy_path'
         @AnalyticsDetails.query.axis: #FREE
         hierarchy_path

}
//where
//  Material = $parameters.p_matnr


----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
