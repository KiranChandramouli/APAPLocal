*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.B.SERVICE.LST.CLEAR.SELECT
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION

*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   T24.BP, is Removed , INSERT FILE MODIFIED
*----------------------------------------------------------------------------------------
****************************************************
* Company : APAP
* Decription: Routine to clear the JOB.LIST, BATCH.STATUS, JOB.STATUS & PROCESS.STATUS for the BATCH record
*             updated in the parameter table "L.APAP.REPORT.SERVICE.PARAM".
* Dev By   : Ashokkumar
*
*****************************************************
    $INSERT  I_COMMON ;*R22 MANUAL CONVERSION
    $INSERT  I_EQUATE
    $INSERT  I_F.LOCKING
    $INSERT  I_F.BATCH ;*R22 MANUAL CONVERSION
    $INSERT  I_F.TSA.SERVICE
    $INSERT  I_F.L.APAP.REPORT.SERVICE.PARAM ;*R22 MANUAL CONVERSION
    $INSERT  I_L.APAP.B.SERVICE.LST.CLEAR.COMMON ;*R22 MANUAL CONVERSION


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
