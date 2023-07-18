*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.B.SERVICE.LST.CLEAR.SELECT

****************************************************
* Company : APAP
* Decription: Routine to clear the JOB.LIST, BATCH.STATUS, JOB.STATUS & PROCESS.STATUS for the BATCH record
*             updated in the parameter table "L.APAP.REPORT.SERVICE.PARAM".
* Dev By   : Ashokkumar
*
*****************************************************
    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.LOCKING
    $INSERT T24.BP I_F.BATCH
    $INSERT T24.BP I_F.TSA.SERVICE
    $INSERT LAPAP.BP I_F.L.APAP.REPORT.SERVICE.PARAM
    $INSERT LAPAP.BP I_L.APAP.B.SERVICE.LST.CLEAR.COMMON


    GOSUB SELECT.PROCESS
    RETURN

SELECT.PROCESS:
***************
    PARAM.ID = "SYSTEM"
    ERR.L.APAP.REPORT.SERVICE.PARAM = ''; R.L.APAP.REPORT.SERVICE.PARAM = ''; YSERVICE.NAM = ''
    CALL F.READ(FN.L.APAP.REPORT.SERVICE.PARAM,PARAM.ID,R.L.APAP.REPORT.SERVICE.PARAM,F.L.APAP.REPORT.SERVICE.PARAM,ERR.L.APAP.REPORT.SERVICE.PARAM)
    YSERVICE.NAM = R.L.APAP.REPORT.SERVICE.PARAM<RPT.SERVC.TSA.SERVICE.NAME>
    CALL BATCH.BUILD.LIST('',YSERVICE.NAM)
    RETURN
END
