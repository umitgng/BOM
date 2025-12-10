*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZI_BOM_COMPONENTS_TF
* Description:
*----------------------------------------------------------------------------------------------------------------------

@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@EndUserText.label: 'Bill of Material Table Func.'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZI_BOM_Components_TF
  with parameters
    @Environment.systemField: #CLIENT
    clnt      : syst_mandt,
    @Environment.systemField : #SYSTEM_DATE
    p_date    : datum,
    p_filter  : abap.char( 1333 ),
    p_werks   : werks_d,
    @Consumption.defaultValue: '01'
    p_variant : stalt
returns
{
  key Mandt                   : abap.clnt;
  key BillOfMaterial          : stnum;
  key Material                : matnr;
      Plant                   : werks_d;
      ProductionVersion       : verid;
      ValidityStartDate       : adatm;
      ValidityEndDate         : bdatm;
      BOMHeaderQty            : basmn;
      BOMHeaderQtyUnit        : basme;
      BOMLevel                : abap.char( 50 ); --abap.int4;
      MainProduct             : matnr;
      Parent                  : matnr;
      Component               : matnr;
      BOMItemQty              : kmpmg;
      BOMItemQtyUnit          : kmpme;
      ComponentScrapInPercent : kausf;
      BOMValidityStartDate    : datuv;
      BOMValidityEndDate      : datuv;
      BaseUnit                : meins;
      CoProduct               : kzkup;
      IsPhantomItem           : abap.char( 1 );
      node                    : int4; --char10;
      hierarchy_path          : abap.char( 250 );
}
implemented by method
  ZCL_PP_BOM_AMDP=>get_data;

----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
