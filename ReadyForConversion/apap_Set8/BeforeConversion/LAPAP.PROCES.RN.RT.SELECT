*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.PROCES.RN.RT.SELECT
*--------------------------------------------------------------------------------------------------
* Description           : Rutina SELECT para el proceso de actualizacion RN o RT
* Developed On          : 23-10-2021
* Developed By          : APAP
* Development Reference : ET-5416
*--------------------------------------------------------------------------------------------------
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_BATCH.FILES
    $INSERT T24.BP I_TSA.COMMON
    $INSERT T24.BP I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT T24.BP I_F.AA.OVERDUE
    $INSERT T24.BP I_F.AA.ARRANGEMENT
    $INSERT LAPAP.BP I_LAPAP.PROCES.RN.RT.COMMON



    CALL EB.CLEAR.FILE(FN.LAPAP.CONCATE.RN.RT, FV.LAPAP.CONCATE.RN.RT)
    SEL.CMD = " SELECT " : FN.AA.ARRANGEMENT.ACTIVITY:" WITH EFFECTIVE.DATE EQ ":TODAY:" AND ACTIVITY EQ ":Y.ACTIVIDAD
    CALL EB.READLIST(SEL.CMD, SEL.LIST,'',NO.OF.RECS,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

    RETURN

END
