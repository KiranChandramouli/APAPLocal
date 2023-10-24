* @ValidationCode : MjotMTI0OTcyNzM0ODpDcDEyNTI6MTY5MTc1MTM0NTI5MzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Aug 2023 16:25:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.BULK.PR.RT.LOAD
*------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion           BP is removed from insert file.
*-------------------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE ;*R22 MANUAL CODE CONVERSION.START
    $INSERT I_COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_System
    $INSERT I_F.DATES
    $INSERT I_F.LAPAP.BULK.PAYROLL
    $INSERT I_F.ST.LAPAP.BULK.PAYROLL.DET
    $INSERT I_LAPAP.BULK.PR.RT.COMMON  ;*R22 MANUAL CODE CONVERSION.END

    GOSUB DO.INITIALIZE
    GOSUB GET.LRT
    GOSUB GET.PENDING.PR
RETURN

DO.INITIALIZE:
    FN.BPR = 'F.ST.LAPAP.BULK.PAYROLL'
    F.BPR = ''
    CALL OPF(FN.BPR,F.BPR)

    FN.BPRD = 'FBNK.ST.LAPAP.BULK.PAYROLL.DET'
    F.BPRD = ''
    CALL OPF(FN.BPRD,F.BPRD)

RETURN

GET.LRT:
    APPL.NAME.ARR = "FUNDS.TRANSFER"
    FLD.NAME.ARR = "L.COMMENTS" : @VM : "L.PAYROLL.ID" : @VM : "L.FTST.ACH.PART"
    CALL MULTI.GET.LOC.REF(APPL.NAME.ARR,FLD.NAME.ARR,FLD.POS.ARR)
    Y.L.COMMENTS.POS = FLD.POS.ARR<1,1>
    Y.L.PAYROLL.ID.POS = FLD.POS.ARR<1,2>
    Y.L.FTST.ACH.PART.POS  = FLD.POS.ARR<1,3>

RETURN

GET.PENDING.PR:
    SEL.ERR = ''; SEL.LIST = ''; SEL.REC = ''; SEL.CMD = ''
    SEL.CMD = "SELECT " : FN.BPR : " WITH PAYROLL.STATUS EQ PENDING"

    CALL OCOMO("SEL.CMD : " : SEL.CMD)

    CALL EB.READLIST(SEL.CMD,SEL.REC,'',SEL.LIST,SEL.ERR)

    Y.PAYROLL.ID.L = ''
    Y.PAYROLL.ARR = ''
    LOOP

        REMOVE Y.PR.ID FROM SEL.REC SETTING TAG

    WHILE Y.PR.ID:TAG
        CALL OCOMO("PAYROLL TO PROCESS = " : Y.PR.ID)
        Y.PAYROLL.ID.L := Y.PR.ID : ' '
        Y.PAYROLL.ARR<-1> = Y.PR.ID
    REPEAT


RETURN


END
