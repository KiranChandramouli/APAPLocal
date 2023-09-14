* @ValidationCode : Mjo4MDUzNzg0OTI6Q3AxMjUyOjE2OTE2NDg4MDQzMjM6SVRTUzotMTotMToxNzA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Aug 2023 11:56:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 170
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.A.UPD.PR.ST.RT
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 09-AUG-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ST.LAPAP.BULK.PAYROLL.DET

    GOSUB GET.LOCAL.REF
    GOSUB GET.PAYROLL.DET
    IF (R.BPRD) THEN
        GOSUB PRELIM.CHECK
        GOSUB POST.OFS
    END

RETURN
PRELIM.CHECK:
    Y.OV = R.NEW(FT.OVERRIDE)
    Y.CNT.OV = DCOUNT(Y.OV,@VM)
    IF (Y.CNT.OV GT 0) THEN
        GOSUB DO.UPD.FAIL
    END

    GOSUB DO.UPD.OK


RETURN

DO.UPD.OK:
    R.BPRD<ST.LAP4.PAYMENT.STATUS> = 'SUCCESSFUL'
    R.BPRD<ST.LAP4.OUR.REFERENCE> = ID.NEW
RETURN

DO.UPD.FAIL:
    R.BPRD<ST.LAP4.PAYMENT.STATUS> = 'FAILED'
    R.BPRD<ST.LAP4.OUR.REFERENCE> = ID.NEW
RETURN

GET.LOCAL.REF:
    APPL.NAME.ARR = "FUNDS.TRANSFER"
    FLD.NAME.ARR = "L.COMMENTS" : @VM : "L.PAYROLL.ID"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    Y.L.COMMENTS.POS = FLD.POS.ARR<1,1>
    Y.L.PAYROLL.ID.POS = FLD.POS.ARR<1,2>


RETURN

GET.PAYROLL.DET:
    FN.BPRD = 'FBNK.ST.LAPAP.BULK.PAYROLL.DET'
    F.BPRD = ''
    CALL OPF(FN.BPRD,F.BPRD)

    Y.PAYROLL = R.NEW(FT.LOCAL.REF)<1,Y.L.PAYROLL.ID.POS>


    CALL F.READ(FN.BPRD,Y.PAYROLL,R.BPRD,F.BPRD,ERR.BPRD)



RETURN

POST.OFS:
    Y.TRANS.ID = Y.PAYROLL
    Y.APP.NAME = "ST.LAPAP.BULK.PAYROLL.DET"
    Y.VER.NAME = Y.APP.NAME :",INPUT"
    Y.FUNC = "I"
    Y.PRO.VAL = "PROCESS"
    Y.GTS.CONTROL = "1"
    Y.NO.OF.AUTH = ""
    FINAL.OFS = ""
    OPTIONS = ""

    CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.BPRD,FINAL.OFS)
    CALL OFS.POST.MESSAGE(FINAL.OFS,'',"PAYROLL.OFS",'')

RETURN
END
