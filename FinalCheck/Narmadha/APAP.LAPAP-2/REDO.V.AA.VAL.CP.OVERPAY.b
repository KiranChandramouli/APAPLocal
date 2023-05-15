* @ValidationCode : MjotMTEzNDQzNzEyNTpDcDEyNTI6MTY4MjQzMDA0MjQzMjpJVFNTOi0xOi0xOjM3OToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 19:10:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 379
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.V.AA.VAL.CP.OVERPAY
*---------------------------------------------------------------------------------
* Description: This routine is to update the contact table REDO.AA.CP.OVERPAYMENT during the
*             VALIDATION stage of AA overpayment through CASH & CHEQUE version.
*
* Version Involved:
*              VERSION>FT,REDO.MULTI.AA.ACRP.UPD.TR
*              VERSION>FT,REDO.MULTI.AA.ACRP.UPD
* Dev By: V.P.Ashokkumar
*
* Date : 10/10/2016
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
*DATE           WHO                 REFERENCE               DESCRIPTION
*21-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     INSERT FILE MODIFIED
*21-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.AA.OVERPAYMENT ;*AUTO R22 CODE CONVERSION END
    $USING APAP.REDOSRTN

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'; F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)
    VAR.AA.ID = ''; FT.TXN.AMT = ''
RETURN

PROCESS:
********
    VAR.AA.ID=R.NEW(FT.CREDIT.ACCT.NO)
    FT.TXN.AMT=R.NEW(FT.DEBIT.AMOUNT)
    IF FT.TXN.AMT EQ '' THEN
        FT.TXN.AMT = R.NEW(FT.CREDIT.AMOUNT)
    END
    R.ACCOUNT = ''; ACC.ERR = ''; ERR.REDO.AA.CP.OVERPAYMENT = ''; R.REDO.AA.CP.OVERPAYMENT = ''
    CALL F.READ(FN.ACCOUNT,VAR.AA.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.AA.ID  = R.ACCOUNT<AC.ARRANGEMENT.ID>
    Y.CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    GOSUB GET.AA.BALANC
* Validated to check the equal sign.
    IF YPEND.AMOUNT EQ 0 OR FT.TXN.AMT GE YPEND.AMOUNT THEN
        ETEXT = 'AA-CANT.GT.THAN.SOURCE.AMOUNT'
        CALL STORE.END.ERROR
        RETURN
    END
RETURN

GET.AA.BALANC:
**************
    OUTSTAND.PRIN.BAL = 0; YPEND.AMOUNT = 0; Y.GET.OVER.PAY.AMT = 0
*CALL REDO.S.GET.OUT.BALANCE(Y.AA.ID,OUTSTAND.PRIN.BAL)
*R22 MANUAL CONVERSION
    CALL APAP.REDOSRTN.redoSGetOutBalance(Y.AA.ID,OUTSTAND.PRIN.BAL)

    SEL.CMD.OVER = ''; SEL.LIST.OVER = ''; SEL.ERR = ''
    SEL.CMD.OVER = 'SELECT ':FN.REDO.AA.OVERPAYMENT:' WITH LOAN.NO EQ ':VAR.AA.ID:' AND STATUS EQ "PENDIENTE"'
    CALL EB.READLIST(SEL.CMD.OVER,SEL.LIST.OVER,'','',SEL.ERR)
    LOOP
        REMOVE OVER.ID FROM SEL.LIST.OVER SETTING OVER.POS
    WHILE OVER.ID:OVER.POS
        REDO.AA.OVERPAYMENT.ERR = ''; R.REDO.AA.OVERPAYMENT = ''
        CALL F.READ(FN.REDO.AA.OVERPAYMENT,OVER.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,REDO.AA.OVERPAYMENT.ERR)
        Y.GET.OVER.PAY.AMT += R.REDO.AA.OVERPAYMENT<REDO.OVER.AMOUNT>
    REPEAT

    YPEND.AMOUNT = OUTSTAND.PRIN.BAL - Y.GET.OVER.PAY.AMT
    YPEND.AMOUNT = ABS(YPEND.AMOUNT)
RETURN
END
