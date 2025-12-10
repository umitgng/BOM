CLASS zcl_pp_bom_amdp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .


    CLASS-METHODS get_data
        FOR TABLE FUNCTION zi_bom_components_tf .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PP_BOM_AMDP IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Static Public Method ZCL_PP_BOM_AMDP=>GET_DATA
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
  METHOD get_data BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY USING zi_billofmaterial
                                              i_materialbomlink
                                              i_product.

*** variable declaration
    declare lv_count integer;
    declare lv_matnr_count integer;
    declare lv_level integer;
    declare lv_material nvarchar(40);
    declare lv_dot nvarchar(20);
    declare lv_dot_level nvarchar(50);


    lt_material = apply_filter ( i_product, :p_filter );

    lt_all_bom = SELECT z.mandt,
                        z.billofmaterial,
                        z.material,
                        z.plant,
                        z.productionversion,
                        z.validitystartdate,
                        z.validityenddate,
                        z.bomheaderqty,
                        z.bomheaderqtyunit,
                        z.material as parent,
                        z.component,
                        z.billofmaterialitemnodenumber,
                        z.bomiteminternalchangecount,
                        z.bomitemqty,
                        z.bomitemqtyunit,
                        z.billofmaterialitemnumber,
                        z.componentscrapinpercent,
                        z.bomvaliditystartdate,
                        z.bomvalidityenddate,
                        z.baseunit,
                        z.coproduct,
                        z.isphantomitem,
                        ltrim(to_nvarchar(z.billofmaterialitemnodenumber), '0') as node,
                        ltrim(  cast( z.billofmaterialitemnodenumber as nvarchar( 250 ) ), '0') as hierarchy_path,
                        z.vgknt,
                        z.vgpzl,
                        z.dvdat,
                        b.producttype
                   from zi_billofmaterial(p_versdat => :p_date, p_variant => :p_variant) as z
                   INNER JOIN i_materialbomlink as a ON a.material = z.material
                                                    and a.plant    = z.plant
                                                    and a.billofmaterialvariant = :p_variant --
                   inner join i_product as b ON b.product = a.material
                   where a.plant                 = :p_werks
*                     AND a.billofmaterialvariant = :p_variant
*                     AND ( b.producttype = 'ZMAM' or b.producttype = 'ZYMM' )
                     AND b.ismarkedfordeletion = ''
                     AND z.mandt = :clnt
                     AND ( z.dvdat < :p_date or z.dvdat is null );

***---* For changed items Control for getting only last component
    lt_all_bom = SELECT * FROM :lt_all_bom AS r1 WHERE NOT EXISTS ( SELECT 1 FROM :lt_all_bom AS r2 WHERE r2.mandt                    = r1.mandt
                                                                                                    and r2.material                 = r1.material
                                                                                                    and r2.plant                    = r1.plant
                                                                                                    and r2.billofmaterialitemnumber = r1.billofmaterialitemnumber
                                                                                                    and r2.vgknt                    = r1.billofmaterialitemnodenumber
                                                                                                    and r2.vgpzl                    = r1.bomiteminternalchangecount  );
***initialize the BOM Level = 1
    lv_level = 1;
    lv_dot   = '.';
    lv_dot_level   = lv_dot || lv_level;

    IF exists (SELECT 1 FROM :lt_material) THEN
***select the data for 1st Level BOM
    root_bom = SELECT a.mandt,
                      a.billofmaterial,
                      a.material,
                      a.plant,
                      a.productionversion ,
                      a.validitystartdate,
                      a.validityenddate,
                      a.bomheaderqty,
                      a.bomheaderqtyunit,
                      lv_dot_level as bomlevel, --:lv_level as bomlevel,
                      material as mainproduct,
                      a.parent,
                      a.component,
                      a.billofmaterialitemnodenumber,
                      a.bomiteminternalchangecount,
                      a.bomitemqty,
                      a.bomitemqtyunit,
                      a.billofmaterialitemnumber,
                      a.componentscrapinpercent,
                      a.bomvaliditystartdate,
                      a.bomvalidityenddate,
                      a.baseunit,
                      a.coproduct,
                      a.isphantomitem,
                      a.node,
                      a.hierarchy_path,
                      a.vgknt,
                      a.vgpzl,
                      a.dvdat,
                      a.producttype
                    from :lt_all_bom as a
                    inner join :lt_material b on b.product = a.material;
*                    where a.producttype = 'ZMAM';
*                      AND ( material = '7357972240E' );
    else
        root_bom = select a.mandt,
                      a.billofmaterial,
                      a.material,
                      a.plant,
                      a.productionversion ,
                      a.validitystartdate,
                      a.validityenddate,
                      a.bomheaderqty,
                      a.bomheaderqtyunit,
                      :lv_count as bomlevel, --:lv_level as bomlevel,
                      material as mainproduct,
                      a.parent,
                      a.component,
                      a.billofmaterialitemnodenumber,
                      a.bomiteminternalchangecount,
                      a.bomitemqty,
                      a.bomitemqtyunit,
                      a.billofmaterialitemnumber,
                      a.componentscrapinpercent,
                      a.bomvaliditystartdate,
                      a.bomvalidityenddate,
                      a.baseunit,
                      a.coproduct,
                      a.isphantomitem,
                      a.node,
                      a.hierarchy_path,
                      a.vgknt,
                      a.vgpzl,
                      a.dvdat,
                      a.producttype
                    from :lt_all_bom as a;
*                    where a.producttype = 'ZMAM';
   end if;

***pass the selected BOM data into OUT_BOM
    out_bom  = select distinct * from :root_bom;


***select the components from the 1st Level BOM
    components = select distinct mandt,
                                 mainproduct,
                                 component,
                                 plant,
                                 node,
                                 hierarchy_path from :root_bom;

***select the count of components from the 1st Level BOM
    select count ( * ) into lv_count from :components;
***if the components are found, check for next level BOM data
    while :lv_count > 0 do
***increment the BOM level
    lv_level = lv_level + 1;
    lv_dot   = lv_dot || '.';
    lv_dot_level = lv_dot || lv_level;
***Max level
    IF lv_level >= 10 then
        break;
    END if;


***get link for components
    links = SELECT a.billofmaterial,
                   a.material
              from i_materialbomlink as a
              inner join :components as b on b.component = a.material
                                         and b.plant     = a.plant
              where a.billofmaterialvariant = :p_variant ;


***select the data for the BOM of components
        child_bom = SELECT a.mandt,
                           a.billofmaterial,
                           a.material,
                           a.plant,
                           a.productionversion ,
                           a.validitystartdate,
                           a.validityenddate,
                           a.bomheaderqty,
                           a.bomheaderqtyunit,
                           lv_dot_level as bomlevel,
                           b.mainproduct,
                           b.component as parent,
                           a.component,
                           a.billofmaterialitemnodenumber,
                           a.bomiteminternalchangecount,
                           a.bomitemqty,
                           a.bomitemqtyunit,
                           a.billofmaterialitemnumber,
                           a.componentscrapinpercent,
                           a.bomvaliditystartdate,
                           a.bomvalidityenddate,
                           a.baseunit,
                           a.coproduct,
                           a.isphantomitem,
                           cast ( a.node as int ) as node,
                           b.hierarchy_path || '-' || a.node  as hierarchy_path,
                           a.vgknt,
                           a.vgpzl,
                           a.dvdat,
                           a.producttype
                     from :lt_all_bom as a
                     inner join :components as b
                       on a.material = b.component
                      and a.plant    = b.plant
                     inner join :links as c
                       on a.billofmaterial = c.billofmaterial
                      and a.material       = c.material
                     where --a.isphantomitem <> 'X' and
                           a.producttype = 'ZYMM';

***select the components from the above selected child BOM
        components = SELECT DISTINCT mandt,
                                     mainproduct,
                                     component,
                                     plant,
                                     node,
                                     hierarchy_path from :child_bom;

***select the count of components from the above selected child BOM
*** if the count of component from this level is 0, then while loop will be terminated
        select COUNT ( * ) into lv_count from :components;

**** Left out join phantom_item_base For eleminate phantom parents
        out_bom = select o.* from :out_bom as o
                    union all
                  select distinct * from :child_bom;

    end while;


***return the data back to table function using RETURN
    return select mandt,
                  billofmaterial,
                  material,
                  plant,
                  productionversion,
                  validitystartdate,
                  validityenddate,
                  bomheaderqty,
                  bomheaderqtyunit,
                  bomlevel,
              	  mainproduct,
                  parent,
                  component,
                  bomitemqty,
                  bomitemqtyunit,
                  componentscrapinpercent,
                  bomvaliditystartdate,
                  bomvalidityenddate,
                  baseunit,
                  coproduct,
                  isphantomitem,
                  node,
                  hierarchy_path from :out_bom;
  endmethod.
ENDCLASS.
