* @ValidationCode : MjotMTU0NjU5ODczNjpDcDEyNTI6MTY4MjMzMTMyMjM4NDpJVFNTOi0xOi0xOjE3NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 175
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.FECHA.CANC.PR.RT(ARRANGEMENT, OUT.ARR)

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       FM to @FM, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY

*********************************************************************************
* Version: 1.0 A.
* Date:    2018/04/10
* By:      Asociacion Popular Ahorros & Prestamos
* Dept:    Requerimientos T.I. Clientes & Captaciones
* Func:    This routine accept the ARRANGEMENT ID, and return its pay off date.
*********************************************************************************
    GOSUB INITIAL
    GOSUB GET.LIST
    GOSUB LOOP.LIST
    GOSUB SET.FINAL.VALUE
RETURN

INITIAL:
    FN.AA.A = "FBNK.AA.ARRANGEMENT.ACTIVITY"
    F.AA.A = ""
    R.AA.A = ""
    AA.A.ERR = ""
    CALL OPF(FN.AA.A,F.AA.A)

    Y.CONT.FLAG = "Y"
RETURN

GET.LIST:
    SEL.CMD.0 = "SELECT " : FN.AA.A : " WITH ARRANGEMENT EQ " : ARRANGEMENT
    CALL EB.READLIST(SEL.CMD.0,SEL.LIST.0,"",NO.OF.RECS.0,SEL.0.ERR)
RETURN

LOOP.LIST:
    LOOP REMOVE Y.ARRANGEMENT.ACTIVITY.ID FROM SEL.LIST.0 SETTING POS.0
    WHILE Y.ARRANGEMENT.ACTIVITY.ID DO
        GOSUB GET.ARR.ACTIVITY
        IF Y.CONT.FLAG EQ "N" THEN
            BREAK
        END

    REPEAT
RETURN

GET.ARR.ACTIVITY:
    Y.AA.ARR.ACT.EFFECTIVE.DATE = ''; Y.AA.ARR.ACT.ACTIVITY = ''
    CALL F.READ(FN.AA.A,Y.ARRANGEMENT.ACTIVITY.ID,R.AA.A,F.AA.A,AA.A.ERR)
    Y.AA.ARR.ACT.EFFECTIVE.DATE = R.AA.A<AA.ARR.ACT.EFFECTIVE.DATE>
    Y.AA.ARR.ACT.ACTIVITY = R.AA.A<AA.ARR.ACT.ACTIVITY>
    IF Y.AA.ARR.ACT.ACTIVITY EQ 'LENDING-APPLYPAYMENT-RP.PAYOFF.CHQ' OR Y.AA.ARR.ACT.ACTIVITY EQ 'LENDING-APPLYPAYMENT-RP.PAYOFF' THEN
        Y.CONT.FLAG = "N"
    END
RETURN

SET.FINAL.VALUE:
    OUT.ARR = Y.AA.ARR.ACT.EFFECTIVE.DATE : @FM : Y.AA.ARR.ACT.ACTIVITY
RETURN
END
