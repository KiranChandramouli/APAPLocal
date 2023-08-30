* @ValidationCode : MjoxMjIyNjg3NTk6Q3AxMjUyOjE2ODA2ODc4MTY3ODI6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:13:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUTH.PIGGY.BANK
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : A Authorisation to generate the PDF for OPEN letter and this routine
* is attached to REDO.ISSUE.CLAIM
*
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : B RENUGADEVI
* PROGRAM NAME : REDO.V.AUT.CLAIMS.OPEN.LETTER
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE              WHO                REFERENCE                       DESCRIPTION
* 16.AUG.2010       BRENUGADEVI        ODR-2009-12-0283               INITIAL CREATION
*05-04-2023       Conversion Tool     R22 Auto Code conversion          No Changes
*05-04-2023           Samaran T        Manual R22 Code Conversion       No Changes
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.LOCKING
    $INSERT I_F.ACCOUNT
    $INSERT I_System
    $INSERT I_F.REDO.H.PIGGY.BANK.ASSIGNMENT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

RETURN

********
PROCESS:
********

    TASK.NAME1  = "TELLER,PIGGY.CASH1 I F3"
    TASK.NAME2 =  "TELLER,PIGGY.CASH I F3"


    Y.DATE1 = TODAY
    CALL System.setVariable("CURRENT.DATE1",Y.DATE1)

    Y.AMT = R.NEW(PB.AS.AMOUNT)
    CALL System.setVariable("CURRENT.AMT",Y.AMT)

    Y.ACCOUNT = R.NEW(PB.AS.DEBIT.ACCOUNT)
    CALL System.setVariable("CURRENT.ACCOUNT",Y.ACCOUNT)

    Y.STATUS = R.NEW(PB.AS.PAY.METHOD)
    IF Y.STATUS EQ 'ACCOUNT DEBIT' THEN
        Y.STATUS.FOR.CHECK = 'PIGGYACCOUNT':'-':ID.NEW
        CALL EB.SET.NEXT.TASK(TASK.NAME1)
    END
    IF Y.STATUS EQ 'CASH' THEN
        Y.STATUS.FOR.CHECK = 'PIGGYCASH':'-':ID.NEW
        CALL EB.SET.NEXT.TASK(TASK.NAME2)
    END
    CALL System.setVariable("CURRENT.STATUS",Y.STATUS.FOR.CHECK)
END
