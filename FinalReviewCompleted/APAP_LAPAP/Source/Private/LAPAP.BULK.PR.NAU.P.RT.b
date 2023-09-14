* @ValidationCode : Mjo5NjYwMzU5MDM6Q3AxMjUyOjE2OTE2NDg4MDQ1MzA6SVRTUzotMTotMToxNzM6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Aug 2023 11:56:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 173
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.BULK.PR.NAU.P.RT(Y.NAU.FT.ID)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 09-AUG-2023      Harsha                R22 Manual Conversion - BP removed from Inserts
    
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.DATES
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.LAPAP.BULK.PAYROLL
    $INSERT I_F.ST.LAPAP.BULK.PAYROLL.DET
    $INSERT I_LAPAP.BULK.PR.NAU.P.RT.COMMON

    GOSUB DO.PROCESS
RETURN

DO.PROCESS:
    CALL OCOMO('Processing :' : Y.NAU.FT.ID)
    GOSUB DO.READ.FT.NAU
    IF (R.FTNAU) THEN
        Y.PAYROLL.ID = R.FTNAU<FT.LOCAL.REF,Y.L.PAYROLL.ID.POS>
        IF (Y.PAYROLL.ID) THEN
            CALL OCOMO('Payroll Id- FTNAU = ' : Y.PAYROLL.ID : '-': Y.NAU.FT.ID)
            GOSUB DO.MARK.FAILED
        END
    END

RETURN

DO.READ.FT.NAU:
    CALL F.READ(FN.FTNAU,Y.NAU.FT.ID,R.FTNAU,F.FTNAU,FTNAU.ERR)
RETURN

DO.MARK.FAILED:
    GOSUB DO.READ.PR.DET
    IF(R.BPRD) THEN
        R.BPRD<ST.LAP4.PAYMENT.STATUS> = 'FAILED'
        R.BPRD<ST.LAP4.OUR.REFERENCE> = ''        ;*Y.NAU.FT.ID

        Y.TRANS.ID = Y.PAYROLL.ID
        Y.APP.NAME = "ST.LAPAP.BULK.PAYROLL.DET"
        Y.VER.NAME = Y.APP.NAME :",INPUT"
        Y.FUNC = "I"
        Y.PRO.VAL = "PROCESS"
        Y.GTS.CONTROL = ""
        Y.NO.OF.AUTH = ""
        FINAL.OFS = ""
        OPTIONS = ""
        R.ACR = ""

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.BPRD,FINAL.OFS)
        CALL OFS.POST.MESSAGE(FINAL.OFS,'',"PAYROLL.OFS",'')

*Send D function to FUNDS.TRANSFER,MB.DM.LOAD for NAU FT
        Y.TRANS.ID = Y.NAU.FT.ID
        Y.APP.NAME = "FUNDS.TRANSFER"
        Y.VER.NAME = Y.APP.NAME :",MB.DM.LOAD"
        Y.FUNC = "D"
        Y.PRO.VAL = "PROCESS"
        Y.GTS.CONTROL = ""
        Y.NO.OF.AUTH = ""
        FINAL.OFS = ""
        OPTIONS = ""
        R.FT = ""

        CALL OFS.BUILD.RECORD(Y.APP.NAME,Y.FUNC,Y.PRO.VAL,Y.VER.NAME,Y.GTS.CONTROL,Y.NO.OF.AUTH,Y.TRANS.ID,R.FT,FINAL.OFS)
        CALL OFS.POST.MESSAGE(FINAL.OFS,'',"PAYROLL.OFS",'')



    END
RETURN

DO.READ.PR.DET:
    CALL F.READ(FN.BPRD,Y.PAYROLL.ID,R.BPRD,F.BPRD,ERR.BPRD)

RETURN
DO.DEL.FUNDS.TRANSFER.NAU:

RETURN

END
