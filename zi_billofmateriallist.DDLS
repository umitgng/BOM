*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZI_BILLOFMATERIALLIST
* Description:
*----------------------------------------------------------------------------------------------------------------------

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Multi Level BOM List'
@Metadata.ignorePropagatedAnnotations: true
@Analytics.settings.maxProcessingEffort:#UNLIMITED
@ObjectModel: {
                usageType: {
                             sizeCategory: #XXL,
                             serviceQuality: #D,
                             dataClass:#TRANSACTIONAL
                           }
                           }
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@ObjectModel.modelingPattern: #ANALYTICAL_CUBE
@ObjectModel.supportedCapabilities:
   [ #ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE ]
define view entity ZI_BILLOFMATERIALLIST
  with parameters
    @Environment.systemField : #SYSTEM_DATE
    p_date    : datum,
    p_filter  : abap.char( 1333 ),
    p_werks   : werks_d,
    @Consumption.defaultValue: '01'
    p_variant : stalt
  as select from ZI_BOM_Components_TF( clnt      : $session.client,
                                       p_date    : $parameters.p_date,
                                       p_filter  : $parameters.p_filter,
                                       p_werks   : $parameters.p_werks,
                                       p_variant : $parameters.p_variant ) as BOM_Components
  association [0..1] to I_ProductText as _text on _text.Language = $session.system_language
{
  key BOM_Components.BillOfMaterial,
  key BOM_Components.Material,
      BOM_Components.Plant,
      BOM_Components.ProductionVersion,
      BOM_Components.ValidityStartDate,
      BOM_Components.ValidityEndDate,
      @Semantics.quantity.unitOfMeasure: 'BOMHeaderQtyUnit'
      BOM_Components.BOMHeaderQty,
      BOM_Components.BOMHeaderQtyUnit,
      BOM_Components.BOMLevel,
      BOM_Components.MainProduct,
      _text[1: Product = $projection.MainProduct ].ProductName as main_text,
      BOM_Components.Parent,
      _text[1: Product = $projection.Parent ].ProductName      as parent_text,
      BOM_Components.Component,
      _text[1: Product = $projection.Component ].ProductName   as comp_text,
      @Semantics.quantity.unitOfMeasure: 'BOMItemQtyUnit'
      BOM_Components.BOMItemQty,
      BOM_Components.BOMItemQtyUnit,
      BOM_Components.ComponentScrapInPercent,
      BOM_Components.BOMValidityStartDate,
      BOM_Components.BOMValidityEndDate,
      BOM_Components.BaseUnit,
      BOM_Components.CoProduct,
      BOM_Components.IsPhantomItem,
      BOM_Components.node,
      BOM_Components.hierarchy_path


}


----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
