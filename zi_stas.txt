*----------------------------------------------------------------------------------------------------------------------
* CDS View:ZI_STAS
* Description:
*----------------------------------------------------------------------------------------------------------------------

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SelectionBOM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_stas
  as select from stas
    inner join   zi_stas_last as last on  last.Stlty = stas.stlty
                                      and last.Stlnr = stas.stlnr
                                      and last.Stlal = stas.stlal
                                      and last.Stlkn = stas.stlkn
                                      and last.datuv = stas.datuv
{
  key stas.stlty     as Stlty,
  key stas.stlnr     as Stlnr,
  key stas.stlal     as Stlal,
  key stas.stlkn     as Stlkn,
  key stas.stasz     as Stasz,
      stas.datuv     as Datuv,
      stas.techv     as Techv,
      stas.aennr     as Aennr,
      stas.lkenz     as Lkenz,
      stas.andat     as Andat,
      stas.annam     as Annam,
      stas.aedat     as Aedat,
      stas.aenam     as Aenam,
      stas.dvdat     as Dvdat,
      stas.dvnam     as Dvnam,
      stas.aehlp     as Aehlp,
      stas.stvkn     as Stvkn,
      stas.idpos     as Idpos,
      stas.idvar     as Idvar,
      stas.lpsrt     as Lpsrt,
      stas.bom_versn as BomVersn
}
where
  stas.lkenz = ''


----------------------------------------------------------------------------------
Extracted by Mass Download version 1.5.5 - E.G.Mellodew. 1998-2025. Sap Release 758
