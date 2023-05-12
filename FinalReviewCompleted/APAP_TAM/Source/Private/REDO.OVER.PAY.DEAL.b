* @ValidationCode : MjotMjEzNzU1NzU0OTpDcDEyNTI6MTY4MzgwOTAyNDY4MTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 May 2023 18:13:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.OVER.PAY.DEAL
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH
*Program   Name    :REDO.OVER.PAY.DEAL
*Reference Number  :ODR-2009-10-0305
*---------------------------------------------------------------------------------

*DESCRIPTION       : This routine is for Generating the Deal Slip if overpayment is Done
*
*LINKED WITH       : TELLER & FT
** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - added APAP.TAM, CALL routine format modified
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DEAL.SLIP.FORMAT
    $INSERT I_GTS.COMMON

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

INIT:
    OFS$DEAL.SLIP.PRINTING = 1
    V$FUNCTION = "A"
    SAVE.APPLICATION = APPLICATION
    LOC.APPLICATION='TELLER':@FM:'FUNDS.TRANSFER'
    LOC.FIELDS='L.TT.OVRDUE.AMT':@VM:'L.TT.INSTAL.AMT':@FM:'L.FT.OVRDUE.AMT':@VM:'L.FT.INSTAL.AMT'
    LOC.POS=''

RETURN

OPEN.FILES:
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

RETURN

**********************************
PROCESS:
*Getting the Local fields position
*Checking for Application
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS) ;*MANUAL R22 CODE CONVERSION
    LOC.TT.OVRDUE.POS = LOC.POS<1,1>
    LOC.TT.INSTAL.POS = LOC.POS<1,2>
    LOC.FT.OVRDUE.POS = LOC.POS<2,1>
    LOC.FT.INSTAL.POS = LOC.POS<2,2>
    IF APPLICATION EQ 'TELLER' THEN
        GOSUB PROCESSTELLER
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESSFT
    END
RETURN
**************************************
PROCESSTELLER:
*Checking for overpayment
    VAR.RECORD.STATUS = R.NEW(TT.TE.RECORD.STATUS)
    VAR.OVRDUE.AMT = R.NEW(TT.TE.LOCAL.REF)<1,LOC.TT.OVRDUE.POS>
    VAR.INSTAL.AMT = R.NEW(TT.TE.LOCAL.REF)<1,LOC.TT.INSTAL.POS>
    VAR.DEPT.ACCT = R.NEW(TT.TE.ACCOUNT.1)
    VAR.DEPT.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)

    IF VAR.RECORD.STATUS EQ 'INAU' THEN
        IF VAR.DEPT.AMT GT VAR.OVRDUE.AMT THEN
            VAR.DEPT.AMT -= VAR.OVRDUE.AMT ;* R22 Auto conversion
            GOSUB CHECK.OVER.PYMT
            IF VAR.ST.CHG.DT EQ TODAY THEN
                VAR.DEPT.AMT -= VAL.BILL.TOT.AMT ;* R22 Auto conversion
                CALL PRODUCE.DEAL.SLIP('TT.OVER.PYMNT')
            END
            IF VAR.DEPT.AMT GT 0 THEN
                CALL PRODUCE.DEAL.SLIP('TT.OVER.PYMNT')
            END
        END
    END
RETURN
*********************************
PROCESSFT:
* process for FUNDS.TRANSFER
    VAR.RECORD.STATUS = R.NEW(FT.RECORD.STATUS)
    VAR.DEPT.AMT = R.NEW(FT.CREDIT.AMOUNT)
    VAR.DEPT.ACCT = R.NEW(FT.CREDIT.ACCT.NO)
    VAR.OVRDUE.AMT = R.NEW(FT.LOCAL.REF)<1,LOC.FT.OVRDUE.POS>
    VAR.INSTAL.AMT = R.NEW(FT.LOCAL.REF)<1,LOC.FT.INSTAL.POS>

    IF VAR.RECORD.STATUS EQ 'INAU' THEN
        IF VAR.DEPT.AMT GT VAR.OVRDUE.AMT THEN
            VAR.DEPT.AMT -= VAR.OVRDUE.AMT ;* R22 Auto conversion
            GOSUB CHECK.OVER.PYMT
            IF VAR.ST.CHG.DT EQ TODAY THEN
                VAR.DEPT.AMT -= VAL.BILL.TOT.AMT ;* R22 Auto conversion
                CALL PRODUCE.DEAL.SLIP('TT.OVER.PYMNT')
            END
            IF VAR.DEPT.AMT GT 0 THEN
                CALL PRODUCE.DEAL.SLIP('TT.OVER.PYMNT')
            END
        END
    END
RETURN
*********************************
CHECK.OVER.PYMT:
    CALL F.READ(FN.ACCOUNT,VAR.DEPT.ACCT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    AA.ACCT.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,AA.ACCT.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ACCT.ERR)
    Y.NO.BILL = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>,@SM)
    VAR2 = 1
    FLAG = ''
    LOOP
    WHILE VAR2 LE Y.NO.BILL
        VAR.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,VAR2,1>
        CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.DET.ERR)
        VAL.BILL.STATUS = R.AA.BILL.DETAILS<AA.BD.BILL.STATUS,1>
        IF VAL.BILL.STATUS EQ 'DUE' AND FLAG NE 1 THEN
            FLAG = 1
            VAR.ST.CHG.DT = R.AA.BILL.DETAILS<AA.BD.BILL.ST.CHG.DT,1>
            VAL.BILL.TOT.AMT = R.AA.BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>
        END
        VAR2 += 1 ;* R22 Auto conversion
    REPEAT
RETURN
END
