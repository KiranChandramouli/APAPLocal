* @ValidationCode : MjotNDEyMTg4NDMyOkNwMTI1MjoxNjgxMjA3NzIwMTIwOklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 15:38:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.OVERDUE.COND
*------------------------------------------------
*Description: This routine is a conversion routine for enquiry REDO.PART.TT.PROCESS.LIST.

** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - lin no 37
*------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.OVERDUE

    GOSUB PROCESS
RETURN
*------------------------------------------------
PROCESS:
*------------------------------------------------

    LOC.REF.APPLICATION = "AA.PRD.DES.OVERDUE"
    LOC.REF.FIELDS      = 'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LOAN.STATUS.1 = LOC.REF.POS<1,1>
    POS.L.LOAN.COND     = LOC.REF.POS<1,2>

    Y.ACC.NO = O.DATA
    IN.ARR.ID = ''
    Y.AA.ID = ''
    CALL REDO.CONVERT.ACCOUNT(Y.ACC.NO,IN.ARR.ID,Y.AA.ID,ERR.TEXT)

    IF Y.AA.ID ELSE
        O.DATA = ''
        RETURN
    END

    EFF.DATE    = ''
    PROP.CLASS  = 'OVERDUE'
    PROPERTY    = ''
    R.CONDITION = ''
    ERR.MSG     = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)

    Y.LOAN.COND   = R.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.COND,1>
    Y.LOAN.STATUS = R.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1,1>
    IF Y.LOAN.COND OR Y.LOAN.STATUS THEN
        O.DATA = Y.LOAN.STATUS:'*':Y.LOAN.COND
    END ELSE
        O.DATA = ''
    END

RETURN
END
