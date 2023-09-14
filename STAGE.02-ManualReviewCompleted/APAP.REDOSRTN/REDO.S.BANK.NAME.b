* @ValidationCode : MjotOTAzNzk0NTY6Q3AxMjUyOjE2ODA3NzM5ODYyMzM6OTE2Mzg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:09:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.BANK.NAME(NAME)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.BANK.NAME
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Bank name and attached in the deal slip REDO.CHQ.DETAIL
*
*LINKED WITH       :
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.CLEARING.OUTWARD
    $INSERT I_F.REDO.H.ROUTING.NUMBER

    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

OPEN.FILE:
*Opening Files

    FN.REDO.CLEARING.OUTWARD = 'F.REDO.CLEARING.OUTWARD'
    F.REDO.CLEARING.OUTWARD = ''
    CALL OPF(FN.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD)

    FN.ROUTING.NUMBER = 'F.REDO.H.ROUTING.NUMBER'
    F.ROUTING.NUMBWER = ''
    CALL OPF(FN.ROUTING.NUMBER,F.ROUTING.NUMBWER)


PROCESS:
*Getting the Description of the Reject Code

    VAR.PAYMENT.DETAILS = R.NEW(FT.PAYMENT.DETAILS)
    CALL F.READ(FN.REDO.CLEARING.OUTWARD,VAR.PAYMENT.DETAILS,R.REDO.CLEARING.OUTWARD,F.REDO.CLEARING.OUTWARD,OUTWARD.ERR)
    VAR.ROUTE.ID = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.ROUTE.NO>

    Y.FIELD.NAME = NAME
    BEGIN CASE
        CASE Y.FIELD.NAME EQ 'BANK.NAME'
            SEL.CMD = 'SELECT ':FN.ROUTING.NUMBER:' WITH BANK.CODE EQ ':VAR.ROUTE.ID
            CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RECS.ERR)
            CALL F.READ(FN.ROUTING.NUMBER,SEL.LIST,R.ROUTING.NUMBER,F.ROUTING.NUMBWER,ROUTING.ERR)
            NAME = R.ROUTING.NUMBER<REDO.ROUT.BANK.NAME>
        CASE Y.FIELD.NAME EQ 'CHEQ.NO'
            NAME = R.REDO.CLEARING.OUTWARD<CLEAR.OUT.CHEQUE.NO>
    END CASE

RETURN

END
