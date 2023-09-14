* @ValidationCode : MjotMTUzNjQ2MDM0MjpDcDEyNTI6MTY4MTE5OTYxMDYyMTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 11 Apr 2023 13:23:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.AMT.PAID
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This routine is used to calculate the remainder amount from cash amt and amt paid
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S                           INITIAL CREATION
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION  FM to @FM , Y.TOTAL.AMT1 + Y.ANT.AMT1 to  Y.TOTAL.AMT1 += Y.ANT.AMT1  , VM to @VM
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------

*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.AA.ARRANGEMENT

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN
*---------
INIT:
    Y.TOTAL.AMT = ''
RETURN

*--------------
OPENFILES:

    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
RETURN
*-------------
PROCESS:

    Y.SET.MODE = R.NEW(REDO.MTS.SETTLEMENT.MODE)
    Y.AMT.TO.BE.PAID = COMI
    Y.PAY.MODE = R.NEW(REDO.MTS.PAYMENT.MODE)<1,AV>

    IF Y.SET.MODE EQ 'CASH' THEN
        Y.BAL.TOT.AMT1 = R.NEW(REDO.MTS.CASH.AMT)
        Y.BAL.TOT.AMT = Y.BAL.TOT.AMT1-Y.AMT.TO.BE.PAID
        R.NEW(REDO.MTS.REMAINDER.AMT) = Y.BAL.TOT.AMT
    END

    IF Y.SET.MODE EQ 'CASH and CHEQUE' THEN
        Y.BAL.TRAN.AMT1 = R.NEW(REDO.MTS.TRANSACTION.AMT)
        Y.BAL.TRAN.AMT = CHANGE(Y.BAL.TRAN.AMT1,@VM,@FM)
        Y.CNT = DCOUNT(Y.BAL.TRAN.AMT,@FM)
        Y.INIT = 1
        LOOP
        WHILE Y.INIT LE Y.CNT
            Y.ANT.AMT1 = Y.BAL.TRAN.AMT<Y.INIT>
            Y.TOTAL.AMT1 += Y.ANT.AMT1 ;*R22 AUTO CODE CONVERSION
            Y.INIT + =1
        REPEAT

        Y.CASH.AMT = R.NEW(REDO.MTS.CASH.AMT)
        Y.BAL.TOT.AMT = Y.CASH.AMT-Y.TOTAL.AMT1
        R.NEW(REDO.MTS.REMAINDER.AMT) = Y.BAL.TOT.AMT
    END

    Y.OPERATION = R.NEW(REDO.MTS.OPERATION)
    IF Y.OPERATION EQ 'REPAYMENT' AND Y.PAY.MODE EQ 'CASH' THEN
        IF Y.BAL.TOT.AMT EQ '0.00' THEN
            R.NEW(REDO.MTS.VERSION.1) = 'TELLER,CASHLESS.1'
            R.NEW(REDO.MTS.VERSION.2) = ''
            R.NEW(REDO.MTS.VERSION.3) = ''
        END ELSE
            R.NEW(REDO.MTS.VERSION.1) = 'TELLER,CASHBACK.2'
            R.NEW(REDO.MTS.VERSION.2) = 'TELLER,CASHBACK.3'
* R.NEW(REDO.MTS.VERSION.3) = 'TELLER,CASHBACK.3'
        END
    END

RETURN
*--------------
GOEND:
END
