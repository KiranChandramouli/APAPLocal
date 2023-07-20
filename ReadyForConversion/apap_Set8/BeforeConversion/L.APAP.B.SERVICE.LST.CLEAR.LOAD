*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE L.APAP.B.SERVICE.LST.CLEAR.LOAD

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


    GOSUB OPEN.FILE
    RETURN

OPEN.FILE:
***********
    FN.L.APAP.REPORT.SERVICE.PARAM = 'F.L.APAP.REPORT.SERVICE.PARAM'; F.L.APAP.REPORT.SERVICE.PARAM = ''
    CALL OPF(FN.L.APAP.REPORT.SERVICE.PARAM,F.L.APAP.REPORT.SERVICE.PARAM)
    FN.LOCKING = 'F.LOCKING'; FV.LOCKING = ''
    CALL OPF(FN.LOCKING,FV.LOCKING)
    FN.BATCH.STATUS = 'F.BATCH.STATUS'; F.BATCH.STATUS = ''
    CALL OPF(FN.BATCH.STATUS,F.BATCH.STATUS)
    FN.BATCH = 'F.BATCH'; F.BATCH = ''
    CALL OPF(FN.BATCH,F.BATCH)
    FN.TSA.SERVICE = 'F.TSA.SERVICE'; F.TSA.SERVICE = ''
    CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)
    RETURN

END
